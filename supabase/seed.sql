SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Clean up existing data to avoid duplicates
DELETE FROM public.favourite_products;
DELETE FROM public.products;
DELETE FROM basejump.account_user;
DELETE FROM basejump.accounts;
DELETE FROM auth.users;
 

-- Insert test users (Each has password '1234')
INSERT INTO auth.users ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'd0416668-470d-4628-a5d8-705ed57cfe80', 'authenticated', 'authenticated', 'john@example.com', '$2a$10$Dmyj.8Rv83KeWV/tTqYGReQtuIDNcSpnrpvJOk5InySU2BFS3ia/6', '2024-04-18 17:38:30.39011+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-04-18 17:38:34.458572+00', '{"provider": "email", "providers": ["email"]}', '{"test_identifier": "test@test.de"}', NULL, '2024-04-18 17:38:30.383695+00', '2024-04-18 17:38:34.46097+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'authenticated', 'authenticated', 'jane@example.com', '$2a$10$Dmyj.8Rv83KeWV/tTqYGReQtuIDNcSpnrpvJOk5InySU2BFS3ia/6', '2024-08-09 14:36:44.060535+00', NULL, '', '2024-08-09 14:36:36.509935+00', '', NULL, '', '', NULL, '2024-08-09 14:36:44.975437+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "bbb00000-0000-0000-0000-000000000000", "email": "family@test.com", "test_identifier": "family@test.com"}', NULL, '2024-08-09 14:36:36.492334+00', '2024-08-09 14:36:44.979887+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'authenticated', 'authenticated', 'alex@example.com', '$2a$10$Dmyj.8Rv83KeWV/tTqYGReQtuIDNcSpnrpvJOk5InySU2BFS3ia/6', '2024-08-09 14:36:44.060535+00', NULL, '', '2024-08-09 14:36:36.509935+00', '', NULL, '', '', NULL, '2024-08-09 14:36:44.975437+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "ccc00000-0000-0000-0000-000000000000", "email": "family2@test.com", "test_identifier": "family2@test.com"}', NULL, '2024-08-09 14:36:36.492334+00', '2024-08-09 14:36:44.979887+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


-- Manually create personal accounts
INSERT INTO basejump.accounts (id, primary_owner_user_id, name, personal_account, created_at, updated_at)
VALUES 
  ('d0416668-470d-4628-a5d8-705ed57cfe80', 'd0416668-470d-4628-a5d8-705ed57cfe80', 'John', true, now(), now()),
  ('b0fa484e-32e4-4551-9493-554cc29d91e5', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'Jane', true, now(), now()),
  ('c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'Alex', true, now(), now());

-- Add users to their personal accounts
INSERT INTO basejump.account_user (user_id, account_id, account_role)
VALUES 
  ('d0416668-470d-4628-a5d8-705ed57cfe80', 'd0416668-470d-4628-a5d8-705ed57cfe80', 'owner'),
  ('b0fa484e-32e4-4551-9493-554cc29d91e5', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'owner'),
  ('c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'owner');
 

-- Create team accounts
INSERT INTO basejump.accounts (id, primary_owner_user_id, name, slug, personal_account, created_at, updated_at)
VALUES 
  ('e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 'd0416668-470d-4628-a5d8-705ed57cfe80', 'Acme Inc', 'acme-inc', false, now(), now()),
  ('f8e9c7a2-4b5d-4e1f-9a8c-6d5e3f2c1b0a', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'Tech Startup', 'tech-startup', false, now(), now());

-- Add team members
INSERT INTO basejump.account_user (user_id, account_id, account_role)
VALUES 
  ('d0416668-470d-4628-a5d8-705ed57cfe80', 'e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 'owner'),
  ('b0fa484e-32e4-4551-9493-554cc29d91e5', 'e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 'member'),
  ('b0fa484e-32e4-4551-9493-554cc29d91e5', 'f8e9c7a2-4b5d-4e1f-9a8c-6d5e3f2c1b0a', 'owner'),
  ('c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'f8e9c7a2-4b5d-4e1f-9a8c-6d5e3f2c1b0a', 'member');

-- Create products
INSERT INTO public.products (id, created_at, title, slug, slogan, description, account_id, prices, is_new)
VALUES
  ('a1b2c3d4-e5f6-4a5b-8c7d-9e8f7a6b5c4d', now(), 'Premium Widget', 'premium-widget', 'The best widget on the market', 'Our premium widget offers unmatched quality and durability.', 'e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 99.99, true),
  ('b2c3d4e5-f6a7-5b6c-9d8e-0f1a2b3c4d5e', now(), 'Budget Widget', 'budget-widget', 'Quality at an affordable price', 'Get all the features you need without breaking the bank.', 'e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 49.99, false),
  ('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', now(), 'Advanced Gadget', 'advanced-gadget', 'Next-gen technology', 'Experience the future with our advanced gadget technology.', 'f8e9c7a2-4b5d-4e1f-9a8c-6d5e3f2c1b0a', 149.99, true),
  ('d4e5f6a7-b8c9-7d0e-1f2a-3b4c5d6e7f8a', now(), 'Smart Device', 'smart-device', 'Intelligence at your fingertips', 'Connect your home with our cutting-edge smart device.', 'f8e9c7a2-4b5d-4e1f-9a8c-6d5e3f2c1b0a', 199.99, true),
  ('e5f6a7b8-c9d0-8e1f-2a3b-4c5d6e7f8a9b', now(), 'Eco-Friendly Tool', 'eco-friendly-tool', 'Green technology for everyone', 'Reduce your carbon footprint with our sustainable tool.', 'e5a9e1d7-8d3e-4c84-9a6b-16bb3f1b7c2d', 79.99, false);

-- Create favorites
INSERT INTO public.favourite_products (id, created_at, updated_at, created_by, updated_by, product_id, account_id)
VALUES
  (extensions.uuid_generate_v4(), now(), now(), 'd0416668-470d-4628-a5d8-705ed57cfe80', 'd0416668-470d-4628-a5d8-705ed57cfe80', 'c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'd0416668-470d-4628-a5d8-705ed57cfe80'),
  (extensions.uuid_generate_v4(), now(), now(), 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'a1b2c3d4-e5f6-4a5b-8c7d-9e8f7a6b5c4d', 'b0fa484e-32e4-4551-9493-554cc29d91e5'),
  (extensions.uuid_generate_v4(), now(), now(), 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'b0fa484e-32e4-4551-9493-554cc29d91e5', 'e5f6a7b8-c9d0-8e1f-2a3b-4c5d6e7f8a9b', 'b0fa484e-32e4-4551-9493-554cc29d91e5'),
  (extensions.uuid_generate_v4(), now(), now(), 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed', 'd4e5f6a7-b8c9-7d0e-1f2a-3b4c5d6e7f8a', 'c2a5ae61-49ef-4513-9bcd-271d4aad26ed');

RESET ALL;