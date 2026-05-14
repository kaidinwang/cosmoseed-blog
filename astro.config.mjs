import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://cosmoseed.com.tw',
  base: '/blog',
  trailingSlash: 'never',
  integrations: [
    sitemap({
      filter: (page) => !page.includes('/draft'),
      serialize(item) {
        return {
          url: item.url,
          changefreq: 'weekly',
          priority: item.url.endsWith('/blog') ? 1.0 : 0.8,
        };
      },
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
  },
  build: {
    format: 'directory',
  },
});
