// .eslintrc.js
module.exports = {
    root: true,
    extends: [
      'next/core-web-vitals',
      'plugin:prettier/recommended'  // adiciona plugin-prettier + eslint-config-prettier
    ],
    plugins: ['prettier'],
    rules: {
      'prettier/prettier': 'error',   // exibe erros de formatação como lint
      // aqui você pode customizar outras regras...
    },
    env: {
      browser: true,
      node: true,
    },
  };
  