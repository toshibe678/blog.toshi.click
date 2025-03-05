// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import remarkLinkCard from 'remark-link-card'
import rehypeRaw from 'rehype-raw'
import rehypeExternalLinks from 'rehype-external-links'

// https://astro.build/config
export default defineConfig({
	site: 'https://example.com',
	integrations: [mdx(), sitemap()],
  markdown: {
		remarkPlugins: [
      [
        remarkLinkCard,
        { shortenUrl: true },
      ],
    ],
    rehypePlugins: [
      rehypeRaw,
      [
        rehypeExternalLinks,
        { target: '_blank' },
      ],
    ],
	},
  vite: {
    server: {
      watch: {
        usePolling: true,
      },
    },
  },
});
