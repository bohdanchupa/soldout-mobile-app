FROM node:14-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (ignore node-sass build scripts)
RUN npm install --ignore-scripts && \
    rm -rf node_modules/node-sass

# Copy project files
COPY . .

# Expose port
EXPOSE 4200

# Start development server on port 4200
CMD ["npx", "quasar", "dev", "--hostname", "0.0.0.0", "--port", "4200"]

