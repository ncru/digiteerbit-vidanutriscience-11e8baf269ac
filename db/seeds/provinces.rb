# run to terminal "rake db:seed:custom_seed SEED=provinces"

Province.delete_all
ActiveRecord::Base.connection.execute("ALTER SEQUENCE provinces_id_seq RESTART WITH 1;")
connection = ActiveRecord::Base.connection()

sql = <<-EOL
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (25, 'AB', 'Abra', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (26, 'AN', 'Agusan Del Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (27, 'AS', 'Agusan Del Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (28, 'AK', 'Aklan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (29, 'AL', 'Albay', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (30, 'AQ', 'Antique', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (31, 'AP', 'Apayao', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (32, 'AU', 'Aurora', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (33, 'BS', 'Basilan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (34, 'BN', 'Bataan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (35, 'BT', 'Batanes', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (36, 'BG', 'Batangas', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (37, 'BE', 'Benguet', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (38, 'BL', 'Biliran', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (39, 'BH', 'Bohol', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (40, 'BK', 'Bukidnon', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (41, 'BC', 'Bulacan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (42, 'CG', 'Cagayan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (43, 'CN', 'Camarines Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (44, 'CS', 'Camarines Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (45, 'CM', 'Camiguin', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (46, 'CZ', 'Capiz', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (47, 'CT', 'Catanduanes', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (48, 'CV', 'Cavite', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (49, 'CE', 'Cebu', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (50, 'CP', 'Compostela Valley', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (51, 'CO', 'Cotabato', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (52, 'DN', 'Davao Del Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (53, 'DS', 'Davao Del Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (54, 'DC', 'Davao Occidental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (55, 'DR', 'Davao Oriental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (56, 'DI', 'Dinagat Islands', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (57, 'ES', 'Eastern Samar', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (58, 'GM', 'Guimaras', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (59, 'IF', 'Ifugao', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (60, 'IN', 'Ilocos Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (61, 'IS', 'Ilocos Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (62, 'IL', 'Iloilo', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (63, 'IA', 'Isabela', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (64, 'KA', 'Kalinga', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (68, 'LU', 'La Union', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (65, 'LG', 'Laguna', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (66, 'LN', 'Lanao Del Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (67, 'LS', 'Lanao Del Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (69, 'LY', 'Leyte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (70, 'MG', 'Maguindanao', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (71, 'MQ', 'Marinduque', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (72, 'MS', 'Masbate', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (73, 'MM', 'Metro Manila', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (74, 'MC', 'Misamis Occidental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (75, 'MR', 'Misamis Oriental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (76, 'MP', 'Mountain Province', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (77, 'NC', 'Negros Occidental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (78, 'NR', 'Negros Oriental', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (79, 'NS', 'Northern Samar', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (80, 'NE', 'Nueva Ecija', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (81, 'NV', 'Nueva Vizcaya', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (82, 'OC', 'Occidental Mindoro', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (83, 'OR', 'Oriental Mindoro', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (84, 'PW', 'Palawan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (85, 'PM', 'Pampanga', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (86, 'PG', 'Pangasinan', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (87, 'QZ', 'Quezon', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (88, 'QI', 'Quirino', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (89, 'RZ', 'Rizal', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (90, 'RM', 'Romblon', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (91, 'SM', 'Samar', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (92, 'SI', 'Sarangani', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (93, 'SQ', 'Siquijor', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (94, 'SO', 'Sorsogon', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (95, 'SC', 'South Cotabato', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (96, 'SL', 'Southern Leyte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (97, 'SK', 'Sultan Kudarat', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (98, 'SU', 'Sulu', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (99, 'SN', 'Surigao Del Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (100, 'SS', 'Surigao Del Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (101, 'TR', 'Tarlac', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (102, 'TW', 'Tawi-Tawi', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (103, 'ZM', 'Zambales', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (104, 'ZN', 'Zamboanga Del Norte', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (105, 'ZS', 'Zamboanga Del Sur', 1, 175);
INSERT INTO public.provinces (id, code, name, status, country_id) VALUES (106, 'ZY', 'Zamboanga Sibugay', 1, 175);
EOL

sql.split(';').each do |s|
  connection.execute(s.strip) unless s.strip.empty?
end

ActiveRecord::Base.connection.reset_pk_sequence!('provinces')
