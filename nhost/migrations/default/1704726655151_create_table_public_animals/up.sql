CREATE TABLE "public"."animals" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "embeddings" vector(1536) NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;
