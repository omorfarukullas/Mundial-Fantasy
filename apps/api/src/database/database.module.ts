import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

export const DB_CONNECTION = 'DB_CONNECTION';

@Global()
@Module({
  providers: [
    {
      provide: DB_CONNECTION,
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const connectionString = configService.get<string>('DATABASE_URL');
        
        if (!connectionString) {
          throw new Error('DATABASE_URL is not defined in the environment variables');
        }

        // prepare: false is required when using Supabase Connection Pooler (PgBouncer)
        const queryClient = postgres(connectionString, { prepare: false });
        
        return drizzle(queryClient, { schema });
      },
    },
  ],
  exports: [DB_CONNECTION],
})
export class DatabaseModule {}
