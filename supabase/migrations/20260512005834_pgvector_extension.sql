-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Add embedding column to players
ALTER TABLE players ADD COLUMN embedding vector(1536);
