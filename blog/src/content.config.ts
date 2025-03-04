import { glob } from 'astro/loaders';
import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
	// Load Markdown and MDX files in the `src/content/blog/` directory.
	loader: glob({ base: './src/content/blog', pattern: '**/*.{md,mdx}' }),
	// Type-check frontmatter using a schema
	schema: z.object({
		title: z.string(),
		description: z.string(),
// Transform YYYYMMDD string to Date object
pubDate: z.string().transform((str) => {
  const year = parseInt(str.substring(0, 4), 10);
  const month = parseInt(str.substring(4, 6), 10) - 1; // months are 0-based in JS
  const day = parseInt(str.substring(6, 8), 10);
  return new Date(year, month, day);
}),
		updatedDate: z.coerce.date().optional(),
		heroImage: z.string().optional(),
	}),
});

export const collections = { blog };
