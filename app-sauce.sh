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
    "./src/**/*.{js,jsx,ts,tsx,.css,.scss}",
    "./public/index.html",
    "./src/index.html"
  ],
  theme: {
    extend: {
      colors: {
        meadow: {
          50: '#f0fdf4',
          600: '#16a34a',
          700: '#15803d',
          200: '#bbf7d0',
        },
        starry: {
          300: '#fda4af',
          500: '#f43f5e',
          600: '#e11d48',
          950: '#500724',
        },
        midnight: {
          500: '#475569',
          600: '#334155',
          700: '#1e293b',
          800: '#0f172a',
          900: '#0f0f1e',
          950: '#030712',
        },
      },
      boxShadow: {
        cosmic: '0 20px 25px -5px rgba(0, 0, 0, 0.5)',
      },
      fontFamily: {
        audiowide: ['Audiowide', 'sans-serif'],
      },
    },
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
  <title>App SAUCE STARTER</title>
  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Audiowide&display=swap" rel="stylesheet">
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
    @apply font-audiowide;
}

@layer base {
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

cat > .gitignore << 'EOL'
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
