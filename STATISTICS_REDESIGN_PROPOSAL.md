# Переробка екрану "Статистика" - UX/UI Proposal

## АНАЛІЗ ПОТОЧНИХ ПРОБЛЕМ

### Layout & Spacing Issues
1. **Відсутність grid системи**: елементи "плавають" без чіткої структури
2. **Непослідовні відступи**: різні margin/padding (50px, 40px, 53px, 32px, 20px)
3. **Великі порожні простори**: 50px logo margin, 53px перед KPI cards
4. **Фіксована ширина**: `.today-total-inf` має `width: 263px` замість responsive

### Visual Hierarchy Issues
1. **Незрозуміла пріоритетність**: всі елементи виглядають рівнозначно
2. **Велика картка "Продано на суму"** має порожнє коло замість значення (проблема UX)
3. **Chart область** виглядає незавершеною (немає заголовку, погана інтеграція легенди)
4. **KPI cards** виглядають як звичайні тексти, а не метрики

### Typography & Readability
1. **Слабка типографічна шкала**: h2=30px, h4=12px (великий стрибок)
2. **Відсутність font-weight диференціації** для ієрархії
3. **Проблеми контрасту**: світлий текст на світлішому фоні карток

### Empty State Issues
1. **Відсутність helpful empty state**: показує просто "0" без пояснення
2. **Немає CTAs** для перших кроків
3. **Порожні кола** створюють відчуття незавершеності

---

## A) UX PROPOSAL: НОВА СТРУКТУРА ЕКРАНУ

### Нова структура секцій (зверху вниз):

```
┌─────────────────────────────────────┐
│ HEADER SECTION (compact)            │
│ - Logo (compact, 32px top margin)   │
│ - Title "Статистика" + Date         │
│ - Safe area top padding             │
└─────────────────────────────────────┘
     ↓ 16px gap
┌─────────────────────────────────────┐
│ PRIMARY METRIC CARD                 │
│ - "Продано на суму"                 │
│ - Велике число (36px font)          │
│ - Іконка/акцент                     │
│ - Empty state: message + CTA        │
└─────────────────────────────────────┘
     ↓ 24px gap
┌─────────────────────────────────────┐
│ KPI GRID (2x2 або 2x1)              │
│ ┌─────────┬─────────┐              │
│ │ Замовлень│ Квитків│              │
│ │ [icon]   │ [icon] │              │
│ │  value   │  value │              │
│ └─────────┴─────────┘              │
└─────────────────────────────────────┘
     ↓ 24px gap
┌─────────────────────────────────────┐
│ CHART CARD                          │
│ - Заголовок "Динаміка за 7 днів"   │
│ - Toggle legend (Замовлено/Квитки) │
│ - Chart area з осями               │
│ - Empty state: "Немає даних"       │
└─────────────────────────────────────┘
     ↓ 16px gap до footer
```

### Чому це краще:

1. **Чіткий vertical flow**: кожна секція має чітку мету
2. **Responsive grid**: KPI grid адаптується під ширину екрану
3. **Компактний header**: більше місця для контенту
4. **Покращена hierarchy**: Primary → Secondary → Tertiary
5. **Структуровані cards**: кожна секція в окремій картці з shadows
6. **Empty states**: кожна секція має meaningful empty state

---

## B) UI SPEC: SPACING, TYPOGRAPHY, COLORS

### Spacing System (8pt Grid)

```scss
// Base unit: 8px
$space-1: 8px;   // 1 unit
$space-2: 16px;  // 2 units
$space-3: 24px;  // 3 units
$space-4: 32px;  // 4 units
$space-5: 40px;  // 5 units
$space-6: 48px;  // 6 units

// Page-level spacing
$page-padding-x: $space-2;      // 16px horizontal
$page-padding-y: $space-4;      // 32px vertical (top)
$section-gap: $space-3;         // 24px between sections
$card-padding: $space-3;        // 24px inside cards

// Component spacing
$header-logo-margin-top: $space-4;        // 32px
$header-title-gap: $space-1;              // 8px
$kpi-grid-gap: $space-2;                  // 16px
$kpi-card-padding: $space-3;              // 24px
```

### Typography Scale

```scss
// Font sizes
$font-xs: 12px;    // Labels, captions
$font-sm: 14px;    // Secondary text
$font-base: 16px;  // Body, dates
$font-lg: 20px;    // Card titles
$font-xl: 28px;    // KPI values
$font-2xl: 36px;   // Primary metric (Продано на суму)

// Font weights (Gotham Pro)
$font-light: 300;
$font-normal: 400;
$font-medium: 500;
$font-bold: 700;

// Line heights
$line-height-tight: 1.2;
$line-height-normal: 1.5;
$line-height-relaxed: 1.75;

// Typography tokens
$typography-primary-metric: (
  size: $font-2xl,
  weight: $font-light,
  line-height: $line-height-tight,
  color: $primary
);

$typography-kpi-value: (
  size: $font-xl,
  weight: $font-light,
  line-height: $line-height-tight,
  color: $primary
);

$typography-card-title: (
  size: $font-sm,
  weight: $font-normal,
  line-height: $line-height-normal,
  color: rgba($primary, 0.8)
);

$typography-label: (
  size: $font-xs,
  weight: $font-normal,
  line-height: $line-height-normal,
  color: rgba($primary, 0.6)
);
```

### Corner Radius & Shadows

```scss
// Border radius
$radius-sm: 12px;   // Small cards, badges
$radius-md: 16px;   // Standard cards (default)
$radius-lg: 20px;   // Large cards, primary metric

// Shadows
$shadow-sm: 0 2px 8px rgba($shadow-color-2, 0.3);
$shadow-md: 0 4px 16px rgba($shadow-color-2, 0.4);
$shadow-lg: 0 8px 24px rgba($shadow-color-2, 0.5);

// Card elevation
$card-elevation-1: $shadow-sm;  // KPI cards
$card-elevation-2: $shadow-md;  // Standard cards
$card-elevation-3: $shadow-lg;  // Primary metric card
```

### Color Tokens (Dark Theme)

```scss
// Background layers
$bg-primary: #1C2435;           // Main app background
$bg-secondary: #222E4D;         // Secondary background
$bg-card: rgba(49, 61, 95, 0.6); // Card background (#313D5F with alpha)
$bg-card-hover: rgba(49, 61, 95, 0.8);

// Text colors
$text-primary: #FFFFFF;                     // Main text
$text-secondary: rgba(255, 255, 255, 0.8); // Secondary text
$text-tertiary: rgba(255, 255, 255, 0.6);  // Labels, hints
$text-disabled: rgba(255, 255, 255, 0.4);  // Disabled state

// Accent colors
$accent-primary: #FD3363;       // Brand accent (pink/red)
$accent-secondary: #46C6FF;     // Secondary accent (blue)
$accent-chart-1: #12BFFF;       // Chart color 1 (Квитки)
$accent-chart-2: #FF608E;       // Chart color 2 (Замовлено)
$accent-chart-3: #66E8CD;       // Chart color 3 (Сума)

// Border colors
$border-default: rgba(255, 255, 255, 0.1);
$border-active: rgba(70, 198, 255, 0.5);

// Gradient backgrounds (existing, keep)
$linear-bg-header: linear-gradient(to bottom, #28375D 0%, #222E4D 50%);
$linear-bg-card: linear-gradient(to left, #556086 0%, #313d5f 100%);
```

---

## C) VUE IMPLEMENTATION GUIDANCE

### Компонентна структура

```
Entry.vue (main page)
├── DashboardHeader.vue (logo + title + date)
├── SalesMetricCard.vue (Продано на суму)
│   └── EmptyState.vue (reusable)
├── KpiGrid.vue (container для KPI cards)
│   └── KpiCard.vue (reusable, Замовлень/Квитків)
└── ChartCard.vue (chart з заголовком та legend)
    └── SineCharts.vue (existing, refactored)
```

### Рекомендований підхід до CSS

**Використовувати CSS Variables (не Tailwind)** - проект вже використовує SCSS зі змінними, краще продовжувати цей підхід для консистентності.

**Структура:**
```scss
// src/css/tokens.scss (новий файл)
:root {
  // Spacing
  --space-1: 8px;
  --space-2: 16px;
  --space-3: 24px;
  // ... etc

  // Typography
  --font-2xl: 36px;
  --font-xl: 28px;
  // ... etc

  // Colors
  --bg-card: rgba(49, 61, 95, 0.6);
  --text-primary: #FFFFFF;
  // ... etc
}

// Використання в компонентах:
.dashboard-card {
  padding: var(--space-3);
  background: var(--bg-card);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-md);
}
```

### Приклад Vue Template Skeleton

```vue
<template>
  <q-page class="page page--statistics">
    <!-- Header Section -->
    <DashboardHeader
      :date="formattedDate"
      class="statistics__header"
    />

    <!-- Primary Metric -->
    <SalesMetricCard
      :value="salesAmount"
      :details="details"
      :is-empty="!details || details.allTicketSum === 0"
      @show-details="handleShowDetails"
      class="statistics__sales-card"
    />

    <!-- KPI Grid -->
    <KpiGrid class="statistics__kpi-grid">
      <KpiCard
        icon="orders"
        label="Замовлень"
        :value="allOrderCount"
        :is-empty="allOrderCount === 0"
      />
      <KpiCard
        icon="tickets"
        label="Квитків"
        :value="allTicketCount"
        :is-empty="allTicketCount === 0"
      />
    </KpiGrid>

    <!-- Chart Section -->
    <ChartCard
      title="Динаміка за 7 днів"
      :charts="charts"
      :has-data="showCharts && hasChartData"
      @marker-click="onMarkerClick"
      class="statistics__chart-card"
    />

    <!-- Details Modal (existing logic) -->
    <total-soulds
      v-if="showDetails && detailsForAnotherDay"
      :details="detailsForAnotherDay"
      :showDetail="true"
    />
  </q-page>
</template>

<script>
export default {
  name: 'Statistics',
  components: {
    'dashboard-header': () => import('../components/DashboardHeader'),
    'sales-metric-card': () => import('../components/SalesMetricCard'),
    'kpi-grid': () => import('../components/KpiGrid'),
    'kpi-card': () => import('../components/KpiCard'),
    'chart-card': () => import('../components/ChartCard'),
    'total-soulds': () => import('../components/TotalSoulds')
  },
  // ... existing data, methods, computed
  computed: {
    formattedDate () {
      // Format date for header
      return this.date
    },
    salesAmount () {
      return this.details?.allTicketSum || 0
    },
    hasChartData () {
      return this.charts.some(chart =>
        chart.points && chart.points.length > 0 &&
        chart.points.some(p => p.y > 0)
      )
    }
  }
}
</script>

<style lang="scss">
@import '../css/tokens';
@import '../css/quasar.variables';

.page--statistics {
  padding: var(--space-4) var(--space-2) var(--space-2);

  // Safe area support
  padding-top: calc(var(--space-4) + env(safe-area-inset-top));
  padding-bottom: calc(64px + env(safe-area-inset-bottom)); // Footer height

  .statistics__header {
    margin-bottom: var(--space-2);
  }

  .statistics__sales-card {
    margin-bottom: var(--section-gap);
  }

  .statistics__kpi-grid {
    margin-bottom: var(--section-gap);
  }

  .statistics__chart-card {
    margin-bottom: var(--space-2);
  }
}
</style>
```

---

## D) EMPTY/ZERO STATE DESIGN

### Empty State для Primary Metric Card

**Коли `allTicketSum === 0`:**

```
┌─────────────────────────────────────┐
│ Продано на суму                     │
│                                     │
│  📊                                  │
│  Поки що немає продажів             │
│                                     │
│  [Додати подію] [Почати продаж]    │
└─────────────────────────────────────┘
```

**Копірайт:**
- Заголовок: "Поки що немає продажів"
- Підзаголовок: "Створіть подію та почніть продавати квитки"
- CTAs:
  1. "Додати подію" (primary, веде на створення події)
  2. "Почати продаж" (secondary, веде на список подій)

### Empty State для KPI Cards

**Коли `value === 0`:**
- Показувати "0" але з меншим розміром шрифту
- Додати subtle hint під числом: "Поки що немає"
- Іконка залишається для візуальної консистентності

### Empty State для Chart

**Коли немає даних:**
```
┌─────────────────────────────────────┐
│ Динаміка за 7 днів                  │
│                                     │
│  [Chart area з placeholder]         │
│  📈                                  │
│  Немає даних для відображення       │
│  Дані з'являться після перших       │
│  продажів                            │
└─────────────────────────────────────┘
```

**Копірайт:**
- Message: "Немає даних для відображення"
- Sub-message: "Дані з'являться після перших продажів"
- Subtle illustration: SVG placeholder графіка

### Implementation Example (EmptyState Component)

```vue
<template>
  <div class="empty-state" :class="{ 'empty-state--compact': compact }">
    <div class="empty-state__icon" v-if="icon">
      <q-icon :name="icon" size="48px" />
    </div>
    <h3 class="empty-state__title">{{ title }}</h3>
    <p class="empty-state__message" v-if="message">{{ message }}</p>
    <div class="empty-state__actions" v-if="actions && actions.length">
      <q-btn
        v-for="(action, idx) in actions"
        :key="idx"
        :label="action.label"
        :color="action.primary ? 'primary' : 'secondary'"
        :outline="!action.primary"
        @click="action.handler"
        class="empty-state__action"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'EmptyState',
  props: {
    icon: String,
    title: { type: String, required: true },
    message: String,
    actions: Array, // [{ label, handler, primary }]
    compact: Boolean
  }
}
</script>
```

---

## E) QUICK WINS LIST (Top 10, < 1 day)

### 1. Додати spacing систему (30 хв)
- Створити `tokens.scss` з 8pt grid
- Замінити hardcoded margins/padding на tokens

### 2. Компактний header (45 хв)
- Зменшити logo margin з 50px до 32px
- Об'єднати title + date в одну секцію з gap 8px

### 3. Покращити Primary Metric Card (1 год)
- Замінити порожнє коло на велике число (36px)
- Додати empty state з message
- Покращити typography (title: 14px, value: 36px)

### 4. Створити KPI Grid компонент (1.5 год)
- Responsive grid (2 columns, gap 16px)
- Окремі KpiCard компоненти
- Додати іконки для кожного KPI

### 5. Покращити KPI Cards (1 год)
- Додати background карток (bg-card color)
- Border-radius 16px
- Shadow для elevation
- Іконки + labels + values

### 6. Додати Chart Card wrapper (45 хв)
- Заголовок "Динаміка за 7 днів"
- Legend toggle (покращити позиціонування)
- Empty state для chart

### 7. Покращити typography scale (30 хв)
- Стандартизувати font sizes (12/14/16/20/28/36)
- Додати font-weight різноманітність
- Покращити line-heights

### 8. Додати card shadows (20 хв)
- Shadow tokens (sm/md/lg)
- Застосувати до всіх cards
- Покращити depth perception

### 9. Empty states для всіх секцій (1.5 год)
- EmptyState component
- Messages для Primary Metric
- Hints для KPI cards
- Placeholder для Chart

### 10. Safe area improvements (30 хв)
- Перевірити padding-bottom для footer
- Перевірити padding-top для header
- Тестувати на iPhone з notch

**Загальний час: ~8 годин** (можна розділити на 2 дні або працювати паралельно над декількома tasks)

---

## IMPLEMENTATION PRIORITY

### Phase 1 (Foundation) - Day 1
1. ✅ Spacing system (tokens.scss)
2. ✅ Typography scale
3. ✅ Color tokens
4. ✅ Compact header

### Phase 2 (Components) - Day 2
5. ✅ KPI Grid + Cards
6. ✅ Improved Primary Metric Card
7. ✅ Chart Card wrapper

### Phase 3 (Polish) - Day 3
8. ✅ Empty states
9. ✅ Shadows & elevation
10. ✅ Safe area final checks

---

## NOTES

- **Не вигадувати нові backend дані** - використовуємо тільки існуючі: `details.allTicketSum`, `allOrderCount`, `allTicketCount`, `charts`
- **Зберегти темну тему** - використовуємо існуючі кольори, покращуємо контраст
- **Mobile-first** - все має працювати на iPhone (375px width)
- **Safe-area support** - враховуємо notch та home indicator
