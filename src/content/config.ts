import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
  schema: z.object({
    title: z.string().max(70),
    description: z.string().min(50).max(160),
    publishDate: z.coerce.date(),
    updateDate: z.coerce.date().optional(),
    author: z.string().default('Din Din Wang 王宣方'),
    category: z.enum(['AEO', 'AI 工具', '行銷', '創業心法', '工作流']),
    tags: z.array(z.string()).default([]),
    featuredImage: z.string().optional(),
    featuredImageAlt: z.string().optional(),
    keywords: z.array(z.string()).default([]),
    faq: z
      .array(
        z.object({
          question: z.string(),
          answer: z.string(),
        })
      )
      .default([]),
    tldr: z.string().optional(),
    canonical: z.string().url().optional(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog };
