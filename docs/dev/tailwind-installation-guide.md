# Tailwind CSS v4 Installation Guide for Rails with Vite

This guide documents how to install and configure Tailwind CSS v4 in a Rails application using Vite as the build tool.

## Overview

Tailwind CSS v4 introduces a new configuration approach that uses CSS-based configuration instead of JavaScript config files. This integration uses the `@tailwindcss/vite` plugin for seamless integration with Vite.

## Installation Steps

### 1. Install Required Packages

Add Tailwind CSS v4 and the Vite plugin to your project:

```bash
npm install --save-dev tailwindcss @tailwindcss/vite
```

This will install:
- `tailwindcss`: The core Tailwind CSS v4 library
- `@tailwindcss/vite`: The official Vite plugin for Tailwind CSS v4

### 2. Configure Vite

Update your `vite.config.ts` file to include the Tailwind plugin:

```typescript
import { defineConfig } from 'vite'
import ViteRails from "vite-plugin-rails"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
  plugins: [
    ViteRails({
      envVars: { RAILS_ENV: "development" },
      envOptions: { defineOn: "import.meta.env" },
      fullReload: {
        additionalPaths: [],
      },
    }),
    tailwindcss(), // Add this line
  ],
})
```

### 3. Update CSS Configuration

Modify your main CSS file (`app/frontend/stylesheets/index.css`) to import Tailwind and configure content sources:

```css
@import "tailwindcss";

/* Your existing CSS imports */
@import "./base.css";
@import "./posts.css";
@import "./environment.css";

/* Configure content sources using @source directive */
@source "../../../app/views/**/*.html.erb";
@source "../../../app/views/**/*.rb";
@source "../../../app/helpers/**/*.rb";
```

The `@source` directives tell Tailwind CSS v4 where to look for class usage. This replaces the traditional `content` array in the JavaScript config file.

### 4. Remove Old Configurations (if upgrading)

If you're upgrading from Tailwind CSS v3:

1. **Delete `tailwind.config.js`** - No longer needed in v4
2. **Remove PostCSS config** - The Vite plugin handles processing
3. **Update CSS imports** - Remove old directives like:
   - `@tailwind base;`
   - `@tailwind components;`
   - `@tailwind utilities;`

   Replace with: `@import "tailwindcss";`

## Configuration in Tailwind CSS v4

### Content Detection

Tailwind CSS v4 uses CSS-based configuration. Content sources are defined using the `@source` directive directly in your CSS:

```css
/* Scan Rails view files */
@source "../../../app/views/**/*.html.erb";
@source "../../../app/views/**/*.rb";

/* Scan helper files */
@source "../../../app/helpers/**/*.rb";

/* Add JavaScript/TypeScript files if using Stimulus */
@source "../controllers/**/*.{js,ts}";
@source "../components/**/*.{js,ts}";
```

### Theme Customization

In Tailwind CSS v4, theme customization is done using CSS variables and `@theme` directives:

```css
@import "tailwindcss";

@theme {
  /* Custom colors */
  --color-primary: #3B82F6;
  --color-secondary: #10B981;

  /* Custom spacing */
  --spacing-custom: 1.25rem;

  /* Custom fonts */
  --font-family-heading: "Inter", sans-serif;
}
```

### Using Plugins

Tailwind CSS v4 plugins are imported directly in your CSS:

```css
@import "tailwindcss";
@import "@tailwindcss/forms";
@import "@tailwindcss/typography";
```

## Usage in Rails Views

Once configured, you can use Tailwind utility classes in your Rails views:

```erb
<!-- app/views/posts/index.html.erb -->
<h1 class="text-3xl font-bold text-blue-600 mb-4">Posts</h1>

<%= link_to "New Post", new_post_path,
    class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" %>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <% @posts.each do |post| %>
    <div class="bg-white rounded-lg shadow-md p-6">
      <h3 class="text-xl font-semibold mb-2">
        <%= link_to post.title, post, class: "text-blue-600 hover:underline" %>
      </h3>
      <p class="text-gray-600"><%= truncate(post.body, length: 150) %></p>
    </div>
  <% end %>
</div>
```

## Development Workflow

### Starting the Development Server

Use the Rails development script which starts both Rails and Vite:

```bash
bin/dev
```

This will:
1. Start the Rails server on port 3000
2. Start the Vite development server with hot module replacement
3. Automatically rebuild CSS when you change Tailwind classes

### Building for Production

For production builds, Vite will automatically optimize and purge unused CSS:

```bash
bin/rails assets:precompile
```

## Key Differences from Tailwind CSS v3

1. **No JavaScript Config**: Configuration is done entirely in CSS using directives
2. **Built-in Vite Support**: Native integration through `@tailwindcss/vite` plugin
3. **Improved Performance**: Faster builds and smaller output sizes
4. **CSS-based Content Detection**: Use `@source` directives instead of `content` array
5. **Simplified Setup**: No need for PostCSS configuration

## Troubleshooting

### Classes Not Being Applied

If Tailwind classes aren't working:

1. **Check @source paths**: Ensure paths in `@source` directives are correct relative to the CSS file
2. **Restart Vite**: Stop and restart `bin/dev` to pick up configuration changes
3. **Clear cache**: Run `bin/rails tmp:clear` and restart the development server

### Build Errors

If you encounter build errors:

1. **Check Node version**: Ensure you're using Node.js 20.9.0 or higher
2. **Clean install**: Remove `node_modules` and run `npm install` again
3. **Check Vite config**: Ensure the Tailwind plugin is properly imported and added to the plugins array

### Styles Not Updating

If styles aren't updating in development:

1. **Check HMR**: Ensure Vite's hot module replacement is working (check browser console)
2. **Hard refresh**: Try a hard refresh in your browser (Cmd+Shift+R on Mac)
3. **Check file watching**: Ensure Vite is watching the correct directories

## Additional Resources

- [Tailwind CSS v4 Documentation](https://tailwindcss.com/docs)
- [Vite Plugin for Tailwind](https://github.com/tailwindlabs/tailwindcss/tree/next/packages/@tailwindcss/vite)
- [Rails + Vite Integration](https://vite-ruby.netlify.app/)

## Version Information

This guide is based on:
- Tailwind CSS: v4.1.11
- @tailwindcss/vite: v4.1.11
- Vite: v5.0.0
- Rails: 8.0
- Node.js: 20.9.0 or higher
