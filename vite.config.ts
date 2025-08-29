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
    tailwindcss(),
  ],
})
