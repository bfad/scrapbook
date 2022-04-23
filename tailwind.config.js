const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

module.exports = {
  corePlugins: {
    preflight: false,
  },
  prefix: 'sb-',
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  // NOTE: Might want to put theme stuff in preflight-reset configuration
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    plugin(function({ addVariant }) {
      addVariant('children', '& > *')
      addVariant('children-hover', '& > *:hover')
    }),
  ]
}
