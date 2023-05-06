CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "full_name" varchar NOT NULL,
  "avatar" varchar,
  "email" varchar UNIQUE NOT NULL,
  "phone" varchar NOT NULL,
  "hashed_password" varchar NOT NULL,
  "user_role" varchar NOT NULL DEFAULT 'user',
  "password_changed_at" timestamp NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "shop_categories" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "shops" (
  "id" bigserial PRIMARY KEY,
  "owner_id" bigint NOT NULL,
  "shop_name" varchar NOT NULL,
  "shop_address" varchar,
  "cover_image" varchar,
  "avatar" varchar,
  "shop_phone" varchar,
  "description" varchar,
  "total_view" integer DEFAULT 0,
  "shop_category_id" bigint NOT NULL,
  "socials" jsonb DEFAULT '[]',
  "status" varchar NOT NULL DEFAULT 'active',
  "admin_status" varchar NOT NULL DEFAULT 'normal',
  "shopname_changed_at" timestamp NOT NULL DEFAULT '0001-01-01 00:00:00Z',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "shop_members" (
  "id" bigserial PRIMARY KEY,
  "member_id" bigint NOT NULL,
  "shop_id" bigint NOT NULL,
  "member_role" varchar NOT NULL DEFAULT 'view',
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "post_categories" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "shop_reports" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "post_reports" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "shops_shop_reports" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "shop_id" bigint NOT NULL,
  "shop_report_id" bigint NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "posts_post_reports" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "post_id" bigint NOT NULL,
  "post_report_id" bigint NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "posts" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "shop_id" bigint NOT NULL,
  "cover_image" varchar,
  "images" text[],
  "post_title" varchar,
  "selling_address" varchar,
  "selling_city" varchar,
  "selling_district" varchar,
  "selling_ward" varchar,
  "city_code" integer,
  "district_code" integer,
  "ward_code" integer,
  "price" integer NOT NULL DEFAULT 0,
  "post_category_id" bigint NOT NULL,
  "post_content" varchar,
  "post_note" varchar,
  "total_view" integer DEFAULT 0,
  "post_type" varchar NOT NULL DEFAULT 'time',
  "expiration_date" timestamp,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "post_change_histories" (
  "id" bigserial PRIMARY KEY,
  "post_id" bigint NOT NULL,
  "user_id" bigint NOT NULL,
  "old_content" varchar,
  "new_content" varchar,
  "old_note" varchar,
  "new_note" varchar,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "post_comments" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "post_id" bigint NOT NULL,
  "comment_content" varchar,
  "star_rating" integer DEFAULT 0,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "post_reply_comments" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "post_id" bigint NOT NULL,
  "post_comment_id" bigint NOT NULL,
  "comment_content" varchar NOT NULL,
  "status" varchar NOT NULL DEFAULT 'active',
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE "posts_saved" (
  "id" bigserial PRIMARY KEY,
  "user_id" bigint NOT NULL,
  "post_id" bigint NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE INDEX ON "shops" ("owner_id");

CREATE INDEX ON "shops" ("shop_category_id");

CREATE INDEX ON "shop_members" ("member_id");

CREATE INDEX ON "shops_shop_reports" ("user_id");

CREATE INDEX ON "shops_shop_reports" ("shop_id");

CREATE INDEX ON "shops_shop_reports" ("shop_report_id");

CREATE INDEX ON "posts_post_reports" ("user_id");

CREATE INDEX ON "posts_post_reports" ("post_id");

CREATE INDEX ON "posts_post_reports" ("post_report_id");

CREATE INDEX ON "posts" ("user_id");

CREATE INDEX ON "posts" ("shop_id");

CREATE INDEX ON "posts" ("post_category_id");

CREATE INDEX ON "posts" ("created_at");

CREATE INDEX ON "post_change_histories" ("user_id");

CREATE INDEX ON "post_change_histories" ("post_id");

CREATE INDEX ON "post_comments" ("user_id");

CREATE INDEX ON "post_comments" ("post_id");

CREATE INDEX ON "post_comments" ("user_id", "post_id");

CREATE INDEX ON "post_comments" ("star_rating");

CREATE INDEX ON "post_reply_comments" ("user_id");

CREATE INDEX ON "post_reply_comments" ("post_id");

CREATE INDEX ON "post_reply_comments" ("user_id", "post_id", "post_comment_id");

CREATE INDEX ON "post_reply_comments" ("post_comment_id");

CREATE INDEX ON "posts_saved" ("user_id");

CREATE INDEX ON "posts_saved" ("post_id");

CREATE INDEX ON "posts_saved" ("user_id", "post_id");

COMMENT ON COLUMN "shop_categories"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "shops"."socials" IS '[{social:"facebook",url:"https://facebook.com"}]';

COMMENT ON COLUMN "shops"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "shops"."admin_status" IS 'normal, stop';

COMMENT ON COLUMN "shop_members"."member_role" IS 'view, edit';

COMMENT ON COLUMN "shop_members"."status" IS 'active, delete';

COMMENT ON COLUMN "post_categories"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "shop_reports"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "post_reports"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "posts"."post_type" IS 'time, notime';

COMMENT ON COLUMN "posts"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "post_change_histories"."status" IS 'active, unactive, delete';

COMMENT ON COLUMN "post_comments"."status" IS 'active, delete';

COMMENT ON COLUMN "post_reply_comments"."status" IS 'active, delete';

ALTER TABLE "shops" ADD FOREIGN KEY ("owner_id") REFERENCES "users" ("id");

ALTER TABLE "shops" ADD FOREIGN KEY ("shop_category_id") REFERENCES "shop_categories" ("id");

ALTER TABLE "shop_members" ADD FOREIGN KEY ("member_id") REFERENCES "users" ("id");

ALTER TABLE "shop_members" ADD FOREIGN KEY ("shop_id") REFERENCES "users" ("id");

ALTER TABLE "shops_shop_reports" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "shops_shop_reports" ADD FOREIGN KEY ("shop_id") REFERENCES "shops" ("id");

ALTER TABLE "shops_shop_reports" ADD FOREIGN KEY ("shop_report_id") REFERENCES "shop_reports" ("id");

ALTER TABLE "posts_post_reports" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "posts_post_reports" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "posts_post_reports" ADD FOREIGN KEY ("post_report_id") REFERENCES "post_reports" ("id");

ALTER TABLE "posts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "posts" ADD FOREIGN KEY ("shop_id") REFERENCES "users" ("id");

ALTER TABLE "posts" ADD FOREIGN KEY ("post_category_id") REFERENCES "post_categories" ("id");

ALTER TABLE "post_change_histories" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "post_change_histories" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "post_comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "post_comments" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "post_reply_comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "post_reply_comments" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "post_reply_comments" ADD FOREIGN KEY ("post_comment_id") REFERENCES "post_comments" ("id");

ALTER TABLE "posts_saved" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "posts_saved" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");
