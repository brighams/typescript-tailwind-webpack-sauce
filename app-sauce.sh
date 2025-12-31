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

  p {
    @apply font-roboto mb-4;
  }

  label {
    @apply font-comfortaa;
  }

  button, a.btn {
    @apply font-comfortaa;
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

const App: React.FC = () => {
  return (
    <div>
      🚀🚀🚀    🪐App.tsx 🪐
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
        comfortaa: ['Comfortaa', 'sans-serif'],
        roboto: ['"Roboto Serif"', 'serif'],
        emoji: ['"Noto Color Emoji"', 'sans-serif'],
      },
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
echo "🚀🚀🚀    🪐ThemeContext.tsx 🪐"
cat > src/components/themes/ThemeContext.tsx << 'EOL'
import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

type Theme = 'midnight-van-gough' | 'sunlit-meadow';

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<Theme>(() => {
    // Get theme from local storage or use default
    const savedTheme = localStorage.getItem('theme') as Theme;
    return savedTheme || 'midnight-van-gough';
  });

  useEffect(() => {
    // Save theme to local storage when it changes
    localStorage.setItem('theme', theme);

    // Apply theme classes to document
    const root = window.document.documentElement;

    if (theme === 'midnight-van-gough') {
      root.classList.add('dark');
    } else {
      root.classList.remove('dark');
    }
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};
EOL
echo "🚀🚀🚀    🪐ThemeSwitcher.tsx 🪐"
cat > src/components/themes/ThemeSwitcher.tsx << 'EOL'
import React from 'react';
import { useTheme } from './ThemeContext';

export const ThemeSwitcher: React.FC = () => {
  const { theme, setTheme } = useTheme();

  const toggleTheme = () => {
    setTheme(theme === 'midnight-van-gough' ? 'sunlit-meadow' : 'midnight-van-gough');
  };

  return (
    <div className="flex items-center space-x-2">
      <span className="font-comfortaa text-sm dark:text-starry-300 text-meadow-700">
        {theme === 'midnight-van-gough' ? '🌙' : '☀️'}
      </span>
      <label className="relative inline-flex items-center cursor-pointer">
        <input
          type="checkbox"
          className="sr-only peer"
          checked={theme === 'sunlit-meadow'}
          onChange={toggleTheme}
        />
        <div className="w-11 h-6 bg-midnight-300 dark:bg-midnight-800 rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white dark:after:bg-starry-400 after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-sky-300"></div>
      </label>
      <span className="font-comfortaa text-sm dark:text-starry-300 text-meadow-700">
        {theme === 'midnight-van-gough' ? 'Dark' : 'Light'}
      </span>
    </div>
  );
};
EOL
echo "🚀🚀🚀    🪐ThemePreview.tsx 🪐"
cat > src/pages/ThemePreview.tsx << 'EOL'
import React, { useState } from 'react';
import { ThemeSwitcher } from '../components/themes/ThemeSwitcher';

const ThemePreview: React.FC = () => {
  const [inputValue, setInputValue] = useState('');
  const [textareaValue, setTextareaValue] = useState('');
  const [sliderValue, setSliderValue] = useState(50);
  const [checkboxValue, setCheckboxValue] = useState(false);
  const [radioValue, setRadioValue] = useState('option1');
  const [selectValue, setSelectValue] = useState('option1');

  return (
    <div className="min-h-screen transition-colors duration-300 bg-gradient-to-br from-sky-50 to-meadow-100 dark:bg-gradient-to-br dark:from-midnight-950 dark:to-midnight-900">
      <div className="container mx-auto px-4 py-10">
        <header className="mb-10 flex justify-between items-center">
          <h1 className="font-audiowide text-4xl text-meadow-700 dark:text-starry-400">
            StarPlayer Theme Preview
          </h1>
          <ThemeSwitcher />
        </header>

        <section className="mb-10">
          <h2 className="font-audiowide text-2xl mb-4 text-meadow-800 dark:text-starry-300">Typography</h2>

          <div className="space-y-4 mb-6">
            <h1 className="font-audiowide text-3xl text-meadow-800 dark:text-starry-400">Heading 1 (Audiowide)</h1>
            <h2 className="font-audiowide text-2xl text-meadow-700 dark:text-starry-300">Heading 2 (Audiowide)</h2>
            <h3 className="font-audiowide text-xl text-meadow-600 dark:text-starry-200">Heading 3 (Audiowide)</h3>

            <p className="font-comfortaa text-lg text-meadow-700 dark:text-starry-300">UI Label Text (Comfortaa)</p>

            <div className="font-roboto text-base text-meadow-800 dark:text-starry-100">
              <p className="mb-2">This is regular text in Roboto Serif. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in dui mauris. Vivamus hendrerit arcu sed erat molestie vehicula.</p>
              <p>Sed auctor neque eu tellus rhoncus ut eleifend nibh porttitor. Ut in nulla enim. Phasellus molestie magna non est bibendum non venenatis nisl tempor.</p>
            </div>

            <p className="font-emoji text-2xl">Emoji Font: 🚀 🎵 🎧 🎸 🎹 🎼 🎤 🎺 🪐 ✨</p>
          </div>
        </section>

        <section className="mb-10">
          <h2 className="font-audiowide text-2xl mb-6 text-meadow-800 dark:text-starry-300">Color Gradients</h2>

          <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Dark Theme Gradients</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <div className="bg-midnight-glow h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-white">Midnight Glow</span>
            </div>
            <div className="bg-cosmic-aurora h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-white">Cosmic Aurora</span>
            </div>
            <div className="bg-starry-night h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-white">Starry Night</span>
            </div>
            <div className="bg-nebula-burst h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-white">Nebula Burst</span>
            </div>
            <div className="bg-deep-space h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-white">Deep Space</span>
            </div>
          </div>

          <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Light Theme Gradients</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="bg-morning-haze h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-meadow-800">Morning Haze</span>
            </div>
            <div className="bg-sunlit-meadow h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-meadow-800">Sunlit Meadow</span>
            </div>
            <div className="bg-golden-hour h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-meadow-800">Golden Hour</span>
            </div>
            <div className="bg-spring-bloom h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-meadow-800">Spring Bloom</span>
            </div>
            <div className="bg-sunset-glow h-32 rounded-lg shadow-lg flex items-center justify-center">
              <span className="font-comfortaa text-meadow-800">Sunset Glow</span>
            </div>
          </div>
        </section>

        <section className="mb-10">
          <h2 className="font-audiowide text-2xl mb-6 text-meadow-800 dark:text-starry-300">UI Components</h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
            <div>
              <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Cards</h3>
              <div className="space-y-6">
                <div className="bg-white dark:bg-midnight-800 rounded-lg p-6 shadow-lg dark:shadow-cosmic">
                  <h4 className="font-audiowide text-lg mb-2 text-meadow-700 dark:text-starry-400">Basic Card</h4>
                  <p className="font-roboto text-meadow-700 dark:text-starry-200">This is a simple card component with some text content.</p>
                </div>

                <div className="bg-gradient-to-r from-sky-50 to-meadow-50 dark:from-midnight-800 dark:to-midnight-700 rounded-lg p-6 shadow-lg dark:shadow-cosmic">
                  <h4 className="font-audiowide text-lg mb-2 text-meadow-700 dark:text-starry-400">Gradient Card</h4>
                  <p className="font-roboto text-meadow-700 dark:text-starry-200">This card has a subtle gradient background.</p>
                </div>
              </div>
            </div>

            <div>
              <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Buttons</h3>
              <div className="space-y-4">
                <div className="space-x-4">
                  <button className="px-4 py-2 bg-meadow-600 dark:bg-starry-600 text-white font-comfortaa rounded-md hover:bg-meadow-700 dark:hover:bg-starry-700 transition">
                    Primary Button
                  </button>
                  <button className="px-4 py-2 bg-white dark:bg-midnight-700 text-meadow-700 dark:text-starry-300 font-comfortaa border border-meadow-200 dark:border-midnight-500 rounded-md hover:bg-meadow-50 dark:hover:bg-midnight-600 transition">
                    Secondary Button
                  </button>
                </div>

                <div className="space-x-4">
                  <button className="px-4 py-2 bg-cosmic-500 text-white font-comfortaa rounded-md hover:bg-cosmic-600 transition">
                    Accent Button
                  </button>
                  <button className="px-4 py-2 bg-transparent text-meadow-600 dark:text-starry-400 font-comfortaa hover:underline transition">
                    Text Button
                  </button>
                </div>
              </div>
            </div>

            <div>
              <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Form Controls</h3>
              <div className="space-y-4">
                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">Input Field</label>
                  <input
                    type="text"
                    value={inputValue}
                    onChange={(e) => setInputValue(e.target.value)}
                    className="w-full px-3 py-2 border border-meadow-200 dark:border-midnight-600 rounded-md focus:outline-none focus:ring-2 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800 text-meadow-800 dark:text-starry-100"
                    placeholder="Enter some text..."
                  />
                </div>

                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">Textarea</label>
                  <textarea
                    value={textareaValue}
                    onChange={(e) => setTextareaValue(e.target.value)}
                    className="w-full px-3 py-2 border border-meadow-200 dark:border-midnight-600 rounded-md focus:outline-none focus:ring-2 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800 text-meadow-800 dark:text-starry-100"
                    placeholder="Enter multiple lines of text..."
                    rows={3}
                  ></textarea>
                </div>

                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">Select</label>
                  <select
                    value={selectValue}
                    onChange={(e) => setSelectValue(e.target.value)}
                    className="w-full px-3 py-2 border border-meadow-200 dark:border-midnight-600 rounded-md focus:outline-none focus:ring-2 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800 text-meadow-800 dark:text-starry-100"
                  >
                    <option value="option1">Option 1</option>
                    <option value="option2">Option 2</option>
                    <option value="option3">Option 3</option>
                  </select>
                </div>
              </div>
            </div>

            <div>
              <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Other Controls</h3>
              <div className="space-y-4">
                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">Checkbox</label>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={checkboxValue}
                      onChange={(e) => setCheckboxValue(e.target.checked)}
                      className="w-5 h-5 text-meadow-600 dark:text-starry-600 border-meadow-300 dark:border-midnight-500 rounded focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800"
                    />
                    <span className="ml-2 font-roboto text-meadow-700 dark:text-starry-300">
                      I agree to the terms
                    </span>
                  </div>
                </div>

                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">Radio Buttons</label>
                  <div className="space-y-2">
                    <div className="flex items-center">
                      <input
                        type="radio"
                        name="radio-option"
                        value="option1"
                        checked={radioValue === 'option1'}
                        onChange={(e) => setRadioValue(e.target.value)}
                        className="w-5 h-5 text-meadow-600 dark:text-starry-600 border-meadow-300 dark:border-midnight-500 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800"
                      />
                      <span className="ml-2 font-roboto text-meadow-700 dark:text-starry-300">
                        Option 1
                      </span>
                    </div>
                    <div className="flex items-center">
                      <input
                        type="radio"
                        name="radio-option"
                        value="option2"
                        checked={radioValue === 'option2'}
                        onChange={(e) => setRadioValue(e.target.value)}
                        className="w-5 h-5 text-meadow-600 dark:text-starry-600 border-meadow-300 dark:border-midnight-500 focus:ring-meadow-500 dark:focus:ring-starry-500 bg-white dark:bg-midnight-800"
                      />
                      <span className="ml-2 font-roboto text-meadow-700 dark:text-starry-300">
                        Option 2
                      </span>
                    </div>
                  </div>
                </div>

                <div>
                  <label className="block font-comfortaa text-sm text-meadow-700 dark:text-starry-300 mb-1">
                    Slider ({sliderValue})
                  </label>
                  <input
                    type="range"
                    min="0"
                    max="100"
                    value={sliderValue}
                    onChange={(e) => setSliderValue(parseInt(e.target.value))}
                    className="w-full h-2 bg-meadow-200 dark:bg-midnight-600 rounded-lg appearance-none cursor-pointer accent-meadow-600 dark:accent-starry-500"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        <section className="mb-10">
          <h2 className="font-audiowide text-2xl mb-6 text-meadow-800 dark:text-starry-300">Color Swatches</h2>

          <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Midnight Theme Colors</h3>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`midnight-${shade}`} className={`bg-midnight-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-midnight-950'}`}>
                  midnight-{shade}
                </span>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`starry-${shade}`} className={`bg-starry-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-starry-950'}`}>
                  starry-{shade}
                </span>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`cosmic-${shade}`} className={`bg-cosmic-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-cosmic-950'}`}>
                  cosmic-{shade}
                </span>
              </div>
            ))}
          </div>

          <h3 className="font-comfortaa text-xl mb-4 text-meadow-700 dark:text-starry-400">Meadow Theme Colors</h3>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`meadow-${shade}`} className={`bg-meadow-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-meadow-950'}`}>
                  meadow-{shade}
                </span>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`sky-${shade}`} className={`bg-sky-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-sky-950'}`}>
                  sky-{shade}
                </span>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            {[950, 900, 800, 700, 600, 500, 400, 300, 200, 100, 50].map((shade) => (
              <div key={`sunshine-${shade}`} className={`bg-sunshine-${shade} h-16 rounded-lg flex items-center justify-center`}>
                <span className={`font-comfortaa ${shade > 500 ? 'text-white' : 'text-sunshine-950'}`}>
                  sunshine-{shade}
                </span>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
};

export default ThemePreview;
EOL
echo "🚀🚀🚀    🪐Setting up package.json scripts 🪐"
npm pkg set scripts.start="webpack serve --config webpack/webpack.dev.js"
npm pkg set scripts.build="webpack --config webpack/webpack.prod.js"
npm pkg set scripts.type-check="tsc --noEmit"

echo "🚀🚀🚀    🪐Setup complete! Starting the development server... 🪐"
npm start
