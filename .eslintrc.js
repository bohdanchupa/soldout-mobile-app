module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint',
    sourceType: 'module'
  },
  env: {
    browser: true
  },
  extends: [
    'plugin:vue/essential'
  ],
  plugins: [
    'vue'
  ],
  globals: {
    'ga': true,
    'cordova': true,
    '__statics': true,
    'process': true
  },
  rules: {
    'prefer-promise-reject-errors': 'off',
    'no-unused-vars': 'off',
    'no-console': 'off',
    'no-debugger': 'off'
  }
}

