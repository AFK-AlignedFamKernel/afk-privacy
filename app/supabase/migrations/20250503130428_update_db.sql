ALTER TABLE messages ADD COLUMN image_url TEXT;
ALTER TABLE messages ADD COLUMN video_url TEXT;

ALTER TABLE country_messages ADD COLUMN image_url TEXT;
ALTER TABLE country_messages ADD COLUMN video_url TEXT;

ALTER TABLE polls ADD COLUMN image_url TEXT;
ALTER TABLE poll_options ADD COLUMN image_url TEXT;
