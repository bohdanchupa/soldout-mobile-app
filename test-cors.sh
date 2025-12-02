#!/bin/bash

echo "🧪 Testing CORS Preflight for ZUUL Gateway"
echo "==========================================="
echo ""

URL="https://z.test.soldout.com.ua/sold-out-statistic/oauth/token?username=soldout.oo.tt@gmail.com&password=aXLYjbfTNNN_soldout584&grant_type=password"

echo "📡 Sending OPTIONS request (CORS Preflight)..."
echo ""

RESPONSE=$(curl -v -X OPTIONS "$URL" \
  -H "Origin: http://localhost:4200" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: authorization,x-soldout-statistic-app-access" \
  2>&1)

echo "$RESPONSE"
echo ""
echo "==========================================="
echo ""

if echo "$RESPONSE" | grep -q "HTTP/.* 200"; then
    echo "✅ SUCCESS: CORS Preflight returned 200 OK"
elif echo "$RESPONSE" | grep -q "HTTP/.* 204"; then
    echo "✅ SUCCESS: CORS Preflight returned 204 No Content"
elif echo "$RESPONSE" | grep -q "HTTP/.* 403"; then
    echo "❌ FAILED: CORS Preflight returned 403 Forbidden"
    echo "   ZUUL is blocking OPTIONS requests!"
elif echo "$RESPONSE" | grep -q "HTTP/.* 404"; then
    echo "⚠️  WARNING: CORS Preflight returned 404 Not Found"
    echo "   Route might not exist"
else
    echo "❓ UNKNOWN: Check response above"
fi

echo ""
echo "🔍 Looking for CORS headers:"
echo ""

if echo "$RESPONSE" | grep -qi "Access-Control-Allow-Origin"; then
    echo "✅ Access-Control-Allow-Origin: FOUND"
else
    echo "❌ Access-Control-Allow-Origin: NOT FOUND"
fi

if echo "$RESPONSE" | grep -qi "Access-Control-Allow-Headers"; then
    echo "✅ Access-Control-Allow-Headers: FOUND"
else
    echo "❌ Access-Control-Allow-Headers: NOT FOUND"
fi

if echo "$RESPONSE" | grep -qi "Access-Control-Allow-Methods"; then
    echo "✅ Access-Control-Allow-Methods: FOUND"
else
    echo "❌ Access-Control-Allow-Methods: NOT FOUND"
fi

echo ""
echo "==========================================="
echo ""
echo "📋 To fix CORS in ZUUL:"
echo "   1. Add CorsFilter bean"
echo "   2. Allow header: X-SOLDOUT-STATISTIC-APP-ACCESS"
echo "   3. Allow method: OPTIONS"
echo "   4. Return 200 OK on OPTIONS requests"
echo ""

