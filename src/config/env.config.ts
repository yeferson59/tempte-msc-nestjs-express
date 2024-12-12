import { z } from 'zod';

const { PORT } = process.env;

const envConfig = z.object({
  port: z.string().min(4).transform(Number),
});

export const { port } = await envConfig.parseAsync({
  port: PORT,
});
