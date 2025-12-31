#!/bin/bash

npm init -y

echo "🚀🚀🚀    🪐Installing React and TypeScript 🪐"
npm install react@18.2.0 react-dom@18.2.0 typescript@4.9.5 @types/react@18.2.33 @types/react-dom@18.2.14

echo "🚀🚀🚀    🪐Installing Webpack and Plugins 🪐"
npm install webpack@5.88.2 webpack-cli@5.1.4 webpack-dev-server@4.15.1 html-webpack-plugin@5.5.3

echo "🚀🚀🚀    🪐Installing Loaders 🪐"
npm install ts-loader@9.5.0 css-loader@6.8.1 style-loader@3.3.3 file-loader@6.2.0

echo "🚀🚀🚀    🪐Installing Webpack Utilities 🪐"
npm install webpack-merge@5.9.0 dotenv-webpack@8.0.1

echo "🚀🚀🚀    🪐Installing CSS Frameworks 🪐"
npm install tailwindcss@3.4.1 postcss@8.4.31 autoprefixer@10.4.16 postcss-loader@7.3.3

echo "🚀🚀🚀    🪐Installing Additional Packages 🪐"
npm install yaml@2.3.4 axios@1.5.1 react-redux@8.1.3 antd@5.10.2 tailwindcss-animate@1.0.7
npm install react-router-dom@6.20.1 react-use@17.5.0 tailwind-merge@2.2.1 sass@1.69.3

npx tsc --init
npx tailwindcss init

echo "🚀🚀🚀    🪐Creating Directory Structure 🪐"
mkdir -p webpack
mkdir -p src/components src/assets src/styles

echo "🚀🚀🚀    🪐Creating Webpack Configuration Files 🪐"
touch webpack/webpack.common.js
touch webpack/webpack.dev.js
touch webpack/webpack.prod.js

echo "🚀🚀🚀    🪐Creating Source Files 🪐"
touch src/index.tsx
touch src/App.tsx
touch src/index.html
touch src/styles/index.css

echo "🚀🚀🚀    🪐tsconfig.json 🪐"
cat > tsconfig.json << 'EOL'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": false,
    "jsx": "react-jsx",
    "outDir": "./dist",
    "baseUrl": "./src"
  },
  "include": ["src"]
}
EOL

echo "🚀🚀🚀    🪐tailwind.config.js 🪐"
cat > tailwind.config.js << 'EOL'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
    "./public/index.html",
    "./src/index.html"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOL

echo "🚀🚀🚀    🪐postcss.config.js 🪐"
cat > postcss.config.js << 'EOL'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOL

echo "🚀🚀🚀    🪐webpack.common.js 🪐"
cat > webpack/webpack.common.js << 'EOL'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/index.tsx',
  output: {
    path: path.resolve(__dirname, '../dist'),
    filename: '[name].[contenthash].js',
    clean: true,
    publicPath: '/',
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js'],
    alias: {
      components: path.resolve(__dirname, '../src/components/'),
      assets: path.resolve(__dirname, '../src/assets/'),
      styles: path.resolve(__dirname, '../src/styles/'),
    },
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        exclude: /node_modules/,
        use: 'ts-loader',
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader'],
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg)$/i,
        type: 'asset/resource',
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/i,
        type: 'asset/resource',
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.html',
    }),
  ],
};
EOL

echo "🚀🚀🚀    🪐webpack.dev.js 🪐"
cat > webpack/webpack.dev.js << 'EOL'
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');
const Dotenv = require('dotenv-webpack');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    static: './dist',
    hot: true,
    port: 8003,
    historyApiFallback: true,
    proxy: [
      {
        context: ['/api'],
        target: 'https://127.0.0.1:8001',
        secure: false,
        changeOrigin: true,
        pathRewrite: { '^/api': '' },
      }
    ],
  },
  plugins: [
    new Dotenv({
      path: './.env.development',
      safe: true,
      defaults: true,
    }),
  ],
});
EOL

echo "🚀🚀🚀    🪐webpack.prod.js 🪐"
cat > webpack/webpack.prod.js << 'EOL'
const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');
const Dotenv = require('dotenv-webpack');

module.exports = merge(common, {
  mode: 'production',
  devtool: 'source-map',
  plugins: [
    new Dotenv({
      path: './.env.production',
      safe: true,
      defaults: true,
    }),
  ],
  optimization: {
    splitChunks: {
      chunks: 'all',
    },
  },
});
EOL

echo "🚀🚀🚀    🪐.env files 🪐"
touch .env.development
touch .env.production

echo "🚀🚀🚀    🪐index.html 🪐"
cat > src/index.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StarPlayer</title>
  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Audiowide&family=Comfortaa:wght@300..700&family=Roboto+Serif:ital,wght@0,100..900;1,100..900&family=Noto+Color+Emoji&display=swap" rel="stylesheet">
</head>
<body>
  <div id="root"></div>
</body>
</html>
EOL
echo "🚀🚀🚀    🪐index.css 🪐"
cat > src/styles/index.css << 'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
    margin: 0;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    transition: background-color 0.3s ease;
}

@layer base {
    h1, h2, h3, h4, h5, h6 {
        @apply font-audiowide;
    }

    h1 {
        @apply text-3xl mb-6;
    }

    h2 {
        @apply text-2xl mb-4;
    }

    h3 {
        @apply text-xl mb-3;
    }
}

@layer components {
    .btn-primary {
        @apply px-4 py-2 bg-meadow-600 dark:bg-starry-600 text-white font-comfortaa rounded-md hover:bg-meadow-700 dark:hover:bg-starry-700 transition-colors;
    }

    .btn-secondary {
        @apply px-4 py-2 bg-white dark:bg-midnight-700 text-meadow-700 dark:text-starry-300 font-comfortaa border border-meadow-200 dark:border-midnight-500 rounded-md hover:bg-meadow-50 dark:hover:bg-midnight-600 transition-colors;
    }

    .card {
        @apply bg-white dark:bg-midnight-800 rounded-lg p-6 shadow-lg dark:shadow-cosmic;
    }

    .gradient-card {
        @apply bg-gradient-to-r from-sky-50 to-meadow-50 dark:from-midnight-800 dark:to-midnight-700 rounded-lg p-6 shadow-lg dark:shadow-cosmic;
    }

    .form-input {
        @apply w-full px-3 py-2 border border-meadow-200 dark:border-midnight-600 rounded-md focus:outline-none focus:ring-2 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800 text-meadow-800 dark:text-starry-100;
    }
}
EOL


echo "🚀🚀🚀    🪐index.tsx 🪐"
cat > src/index.tsx << 'EOL'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import './styles/index.css';

const container = document.getElementById('root');
const root = createRoot(container!);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

echo "🚀🚀🚀    🪐App.tsx 🪐"
cat > src/App.tsx << 'EOL'
import React from 'react';
import './styles/index.css';

const App: React.FC = () => {
  const openGitHub = () => {
    window.open('https://github.com/brighams/typescript-tailwind-webpack-sauce', '_blank');
  };

  return (
    <div className="min-h-screen w-full bg-gradient-to-br from-midnight-950 via-midnight-900 to-starry-950 dark:from-midnight-950 dark:via-midnight-900 dark:to-starry-950 flex flex-col items-center justify-center relative overflow-hidden">
      {/* Spinning Gear Button - Upper Right */}
      <button
        onClick={openGitHub}
        className="absolute top-8 right-8 z-50 p-4 rounded-full bg-purple-600 hover:bg-purple-700 transition-colors duration-300 shadow-lg hover:shadow-xl"
        title="Visit GitHub Repository"
      >
        <svg
          className="w-8 h-8 text-white animate-spin"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" strokeWidth="1.5" />
          <g transform="translate(12, 12)">
            <circle cx="0" cy="-7" r="1.5" fill="currentColor" />
            <circle cx="6" cy="-3.5" r="1.5" fill="currentColor" />
            <circle cx="6" cy="3.5" r="1.5" fill="currentColor" />
            <circle cx="0" cy="7" r="1.5" fill="currentColor" />
            <circle cx="-6" cy="3.5" r="1.5" fill="currentColor" />
            <circle cx="-6" cy="-3.5" r="1.5" fill="currentColor" />
          </g>
        </svg>
      </button>

      {/* Main Content */}
      <div className="text-center px-8 max-w-3xl">
        <h1 className="font-audiowide text-7xl md:text-3xl font-bold mb-6 text-transparent bg-clip-text bg-gradient-to-r from-purple-400 via-pink-500 to-purple-600 drop-shadow-lg animate-pulse">
          Initialized with love by <span className="text-pink-400">app-sauce.sh</span>
        </h1>

        <p className="font-audiowide text-3xl md:text-2xl text-purple-300 mb-8 drop-shadow-lg">
          ✨ Welcome to your next-generation app! ✨
        </p>

        <p className="font-audiowide text-3xl md:text-base text-purple-300 mb-8 drop-shadow-lg">
          If you wish to add additional files or packages, and share them with a pull request, please duplicate app-sauce.sh, add a file called:
          <div className="text-pink-400"> <code>app-sauce-XXXXXXX.sh</code></div>
          where XXXXXXX identifies the purpose of the file, such as:
          <div className="text-pink-400"> <code>app-sauce-websockets.sh</code></div>
        </p>


        <div className="font-roboto text-xl md:text-2xl text-purple-200 space-y-4 mb-12">
          <p className="text-purple-300">
            Feel free to send pull requests to: <div className="font-bold text-pink-400"><a href='https://github.com/brighams/typescript-tailwind-webpack-sauce'>typescript-tailwind-webpack-sauce on github</a></div>
          </p>
        </div>
      </div>

      {/* Decorative stars background */}
      <div className="absolute inset-0 pointer-events-none opacity-20">
        <div className="absolute top-20 left-10 text-4xl animate-pulse">✨</div>
        <div className="absolute top-40 right-20 text-5xl animate-pulse" style={{animationDelay: '0.5s'}}>⭐</div>
        <div className="absolute bottom-32 left-1/4 text-4xl animate-pulse" style={{animationDelay: '1s'}}>✨</div>
        <div className="absolute bottom-20 right-1/3 text-5xl animate-pulse" style={{animationDelay: '1.5s'}}>⭐</div>
      </div>
    </div>
  );
};

export default App;

EOL
echo "🚀🚀🚀    🪐tailwind.config.js 🪐"
cat > tailwind.config.js << 'EOL'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
    "./public/index.html",
    "./src/index.html"
  ],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        audiowide: ['Audiowide', 'cursive'],
      },
      // EXAMPLE THEME TO SHOW LIGHT/DARK configurations
      colors: {
        // Midnight Van Gogh Theme (Dark)
        'midnight': {
          50: '#f2f0ff',
          100: '#e9e4ff',
          200: '#d4cbff',
          300: '#b8a3ff',
          400: '#9b70ff',
          500: '#8340ff',
          600: '#7627f5',
          700: '#6417db',
          800: '#5315b3',
          900: '#3c1491',
          950: '#220c57',
        },
        'starry': {
          50: '#edfcff',
          100: '#d6f7ff',
          200: '#b5f0ff',
          300: '#83e7ff',
          400: '#48d4ff',
          500: '#1fb8ff',
          600: '#0696ff',
          700: '#007dff',
          800: '#0563ce',
          900: '#0c55a5',
          950: '#0b375e',
        },
        'cosmic': {
          50: '#fffaec',
          100: '#fff4d3',
          200: '#ffe7a5',
          300: '#ffd56d',
          400: '#ffbd3b',
          500: '#ff9d16',
          600: '#fc7b0c',
          700: '#e85b0c',
          800: '#cc4512',
          900: '#a63815',
          950: '#541907',
        },

        // Sunlit Meadow Theme (Light)
        'meadow': {
          50: '#f0fdf3',
          100: '#dbfce5',
          200: '#b9f7cf',
          300: '#86eeab',
          400: '#4bdd7c',
          500: '#25c357',
          600: '#15a043',
          700: '#137f38',
          800: '#146531',
          900: '#11542a',
          950: '#072f17',
        },
        'sky': {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
          950: '#082f49',
        },
        'sunshine': {
          50: '#fffce8',
          100: '#fff9c2',
          200: '#fff088',
          300: '#ffe042',
          400: '#ffd020',
          500: '#ffb506',
          600: '#e28c00',
          700: '#bb6302',
          800: '#984c08',
          900: '#7c3e0c',
          950: '#482000',
        },
      },
      backgroundImage: {
        // Dark theme gradients
        'midnight-glow': 'linear-gradient(135deg, rgb(34, 12, 87, 0.95) 0%, rgb(60, 20, 145, 0.95) 40%, rgb(83, 21, 179, 0.9) 100%)',
        'cosmic-aurora': 'linear-gradient(135deg, rgb(34, 12, 87, 0.9) 0%, rgb(8, 47, 73, 0.9) 50%, rgb(11, 55, 94, 0.85) 100%)',
        'starry-night': 'radial-gradient(ellipse at top, rgba(24, 24, 80, 0.9) 0%, rgba(8, 8, 40, 0.95) 60%), radial-gradient(ellipse at bottom, rgba(54, 19, 125, 0.9) 0%, rgba(13, 13, 45, 0.95) 70%)',
        'nebula-burst': 'linear-gradient(135deg, rgba(34, 12, 87, 0.9) 0%, rgba(115, 41, 166, 0.85) 35%, rgba(202, 59, 98, 0.85) 70%, rgba(255, 122, 69, 0.75) 100%)',
        'deep-space': 'linear-gradient(to bottom, rgba(13, 12, 26, 0.95) 0%, rgba(34, 23, 77, 0.9) 50%, rgba(15, 12, 41, 0.8) 100%)',

        // Light theme gradients
        'morning-haze': 'linear-gradient(135deg, rgba(240, 249, 255, 0.9) 0%, rgba(224, 242, 254, 0.9) 40%, rgba(186, 230, 253, 0.8) 100%)',
        'sunlit-meadow': 'linear-gradient(135deg, rgba(240, 253, 243, 0.9) 0%, rgba(219, 252, 229, 0.85) 40%, rgba(185, 247, 207, 0.75) 100%)',
        'golden-hour': 'linear-gradient(to bottom, rgba(255, 252, 232, 0.9) 0%, rgba(255, 249, 194, 0.85) 35%, rgba(255, 240, 136, 0.75) 100%)',
        'spring-bloom': 'radial-gradient(ellipse at top, rgba(240, 253, 243, 0.9) 0%, rgba(219, 252, 229, 0.85) 60%), radial-gradient(ellipse at bottom, rgba(224, 242, 254, 0.85) 0%, rgba(186, 230, 253, 0.75) 70%)',
        'sunset-glow': 'linear-gradient(135deg, rgba(255, 249, 194, 0.9) 0%, rgba(255, 224, 66, 0.8) 30%, rgba(255, 181, 6, 0.7) 60%, rgba(226, 140, 0, 0.75) 100%)',
      },
      boxShadow: {
        'neon': '0 0 5px theme("colors.starry.400"), 0 0 20px theme("colors.starry.300")',
        'cosmic': '0 0 15px rgba(27, 184, 255, 0.4)',
        'inner-glow': 'inset 0 0 15px rgba(27, 184, 255, 0.3)',
        'sunlit': '0 0 15px rgba(14, 165, 233, 0.3)',
        'meadow-glow': '0 0 15px rgba(37, 195, 87, 0.3)',
      },
    },
  },
  plugins: [
    require('tailwindcss-animate')
  ],
}
EOL

cat > tailwind.config.js << 'EOL'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Diagnostic reports (https://nodejs.org/api/report.html)
report.[0-9]*.[0-9]*.[0-9]*.[0-9]*.json

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release

# Dependency directories
node_modules/
jspm_packages/

# Snowpack dependency directory (https://snowpack.dev/)
web_modules/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional stylelint cache
.stylelintcache

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variable files
.env
.env.*
!.env.example

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and not Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public

# vuepress build output
.vuepress/dist

# vuepress v2.x temp and cache directory
.temp
.cache

# Sveltekit cache directory
.svelte-kit/

# vitepress build output
**/.vitepress/dist

# vitepress cache directory
**/.vitepress/cache

# Docusaurus cache and generated files
.docusaurus

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# Firebase cache directory
.firebase/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v3
.pnp.*
.yarn/*
!.yarn/patches
!.yarn/plugins
!.yarn/releases
!.yarn/sdks
!.yarn/versions

# Vite logs files
vite.config.js.timestamp-*
vite.config.ts.timestamp-*

# for local testing
app/**
EOL

echo "🚀🚀🚀    🪐Setting up package.json scripts 🪐"
npm pkg set scripts.start="webpack serve --config webpack/webpack.dev.js"
npm pkg set scripts.build="webpack --config webpack/webpack.prod.js"
npm pkg set scripts.type-check="tsc --noEmit"

echo "🚀🚀🚀    🪐Setup complete! Starting the development server... 🪐"
npm start
