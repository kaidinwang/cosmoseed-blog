import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import type { APIContext } from 'astro';

export async function GET(context: APIContext) {
  const posts = await getCollection('blog', ({ data }) => !data.draft);

  return rss({
    title: '宇宙種子 CosmoSeed Blog',
    description: 'AEO、AI 工具、品牌行銷、AI 工作流的實戰筆記。',
    site: context.site!.href,
    items: posts
      .sort((a, b) => b.data.publishDate.valueOf() - a.data.publishDate.valueOf())
      .map((post) => ({
        title: post.data.title,
        description: post.data.description,
        pubDate: post.data.publishDate,
        author: post.data.author,
        categories: [post.data.category, ...post.data.tags],
        link: `/blog/${post.id.replace(/\.md$/, '')}/`,
      })),
    customData: '<language>zh-tw</language>',
  });
}
