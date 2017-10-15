-- UPGRADE CARD_ID TO UUID TYPE FOR HISTORIC DATA

-- Update grasp.cards
-- 1. Create UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- 2. Move old card ids
ALTER TABLE grasp.cards RENAME card_id to old_card_id;
-- 3. Create new column
ALTER TABLE grasp.cards ADD card_id UUID DEFAULT uuid_generate_v4();

-- Now update grasp.reports table
-- 4. Mode old card ids
ALTER TABLE grasp.reports RENAME card_id to old_card_id;
ALTER TABLE grasp.reports ADD card_id UUID;

-- 5. Update reports
UPDATE grasp.reports SET card_id = grasp.cards.card_id FROM grasp.cards WHERE grasp.reports.old_card_id = grasp.cards.old_card_id;

-- 6. Drop old columns
ALTER TABLE grasp.cards DROP old_card_id;
ALTER TABLE grasp.reports DROP old_card_id;
