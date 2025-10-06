// @ts-check
import eslint from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';
import prettierRecommended from 'eslint-plugin-prettier/recommended';

/**
 * Ciljevi:
 * - Zadržati type-aware lint (ali smiriti no-unsafe* bučnu trijadu)
 * - Dobar DX za Nest kontrolere/servise
 * - Prettier kroz ESLint
 */
export default tseslint.config(
  // Global ignore-i
  {
    ignores: ['dist', 'node_modules', 'eslint.config.mjs'],
  },

  // Osnovni JS preporučeni set
  eslint.configs.recommended,

  // TypeScript (bez i sa type-checkinga)
  ...tseslint.configs.recommended, // non-type-checked
  ...tseslint.configs.recommendedTypeChecked, // type-checked pravila

  // Prettier integriše kao ESLint pravila
  prettierRecommended,

  // Glavni TS set za app
  {
    files: ['**/*.ts'],
    languageOptions: {
      parserOptions: {
        // projectService je najbolji izbor za flat config (TS v5+)
        // automatski traži tsconfig-e u projektu
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
        sourceType: 'module',
        ecmaVersion: 2023,
      },
      globals: {
        ...globals.node,
      },
    },
    rules: {
      // ⚖️ Ublažavanja – “ugasiti požar”, ali ostavićemo kao 'warn' gde ima smisla
      '@typescript-eslint/no-unsafe-assignment': 'off',
      '@typescript-eslint/no-unsafe-member-access': 'off',
      '@typescript-eslint/no-unsafe-call': 'off',
      '@typescript-eslint/no-unsafe-argument': 'warn',

      // Nest kontroleri često loguju i hvataju 'unknown' – realno ok
      '@typescript-eslint/restrict-template-expressions': 'off',
      '@typescript-eslint/no-explicit-any': 'off',

      // Promise u dekoratorima/express handler-ima – rasterećivanje
      '@typescript-eslint/no-misused-promises': [
        'warn',
        { checksVoidReturn: false },
      ],

      // Eksplicitni povratni tipovi umeju da smetaju dok refaktorišeš
      '@typescript-eslint/explicit-module-boundary-types': 'off',

      // Prettier je već uključen preko recommended konfiguracije
      // Dodatno možeš da dodaš import/order ako želiš:
      // 'import/order': ['warn', { 'newlines-between': 'always' }],
    },
  },

  // Testovi (Jest) – opuštenija pravila
  {
    files: ['**/*.spec.ts', '**/*.test.ts'],
    languageOptions: {
      globals: {
        ...globals.jest,
      },
    },
    rules: {
      '@typescript-eslint/no-unsafe-assignment': 'off',
      '@typescript-eslint/no-unsafe-member-access': 'off',
      '@typescript-eslint/no-unsafe-call': 'off',
      '@typescript-eslint/no-unsafe-argument': 'off',
    },
  },
);
