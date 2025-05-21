-- Script to set up and benchmark pgvector/pgvecto.rs

-- Install extension if not already installed
CREATE EXTENSION IF NOT EXISTS vector;

-- Table for embeddings
DROP TABLE IF EXISTS embeddings;
CREATE TABLE embeddings (
    id bigserial PRIMARY KEY,
    embedding vector(1024)
);

-- Populate table with random embeddings (10000 rows)
INSERT INTO embeddings (embedding)
SELECT array(
    SELECT random()*2-1
    FROM generate_series(1,1024)
)::vector
FROM generate_series(1,10000);

-- Example query vector
\set q "(SELECT array(SELECT random()*2-1 FROM generate_series(1,1024))::vector)"

-- Enable timing output
\timing on

-- Similarity search for different top-k values
EXPLAIN ANALYZE
SELECT id, embedding <-> :q AS distance
FROM embeddings
ORDER BY embedding <-> :q
LIMIT 5;

EXPLAIN ANALYZE
SELECT id, embedding <-> :q AS distance
FROM embeddings
ORDER BY embedding <-> :q
LIMIT 10;

EXPLAIN ANALYZE
SELECT id, embedding <-> :q AS distance
FROM embeddings
ORDER BY embedding <-> :q
LIMIT 25;

EXPLAIN ANALYZE
SELECT id, embedding <-> :q AS distance
FROM embeddings
ORDER BY embedding <-> :q
LIMIT 50;
