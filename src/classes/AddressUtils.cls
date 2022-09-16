public class AddressUtils
{
    public static Map<String,String> cc2Name = new Map<String,String> {'AF'=>'AFGHANISTAN', 'AX'=>'ÅLAND ISLANDS', 'AL'=>'ALBANIA', 'DZ'=>'ALGERIA', 'AS'=>'AMERICAN SAMOA', 
        'AD'=>'ANDORRA', 'AO'=>'ANGOLA', 'AI'=>'ANGUILLA', 'AQ'=>'ANTARCTICA', 'AG'=>'ANTIGUA AND BARBUDA', 'AR'=>'ARGENTINA', 'AM'=>'ARMENIA', 'AW'=>'ARUBA', 
        'AU'=>'AUSTRALIA', 'AT'=>'AUSTRIA', 'AZ'=>'AZERBAIJAN', 'BS'=>'BAHAMAS', 'BH'=>'BAHRAIN', 'BD'=>'BANGLADESH', 'BB'=>'BARBADOS', 'BY'=>'BELARUS', 'BE'=>'BELGIUM', 
        'BZ'=>'BELIZE', 'BJ'=>'BENIN', 'BM'=>'BERMUDA', 'BT'=>'BHUTAN', 'BO'=>'BOLIVIA', 'BQ'=>'BONAIRE, SINT EUSTATIUS AND SABA', 'BA'=>'BOSNIA AND HERZEGOVINA', 
        'BW'=>'BOTSWANA', 'BV'=>'BOUVET ISLAND', 'BR'=>'BRAZIL', 'IO'=>'BRITISH INDIAN OCEAN TERRITORY', 'BN'=>'BRUNEI DARUSSALAM', 'BG'=>'BULGARIA', 'BF'=>'BURKINA FASO', 'BI'=>'BURUNDI', 
        'KH'=>'CAMBODIA', 'CM'=>'CAMEROON', 'CA'=>'CANADA', 'CV'=>'CAPE VERDE', 'KY'=>'CAYMAN ISLANDS', 'CF'=>'CENTRAL AFRICAN REPUBLIC', 'TD'=>'CHAD', 'CL'=>'CHILE', 'CN'=>'CHINA', 
        'CX'=>'CHRISTMAS ISLAND', 'CC'=>'COCOS (KEELING) ISLANDS', 'CO'=>'COLOMBIA', 'KM'=>'COMOROS', 'CG'=>'CONGO', 'CD'=>'THE DEMOCRATIC REPUBLIC OF THE CONGO', 'CK'=>'COOK ISLANDS', 
        'CR'=>'COSTA RICA', 'CI'=>'CÔTE D\'IVOIRE', 'HR'=>'CROATIA', 'CU'=>'CUBA', 'CW'=>'CURAÇAO', 'CY'=>'CYPRUS', 'CZ'=>'CZECH REPUBLIC', 'DK'=>'DENMARK', 'DJ'=>'DJIBOUTI', 'DM'=>'DOMINICA', 
        'DO'=>'DOMINICAN REPUBLIC', 'EC'=>'ECUADOR', 'EG'=>'EGYPT', 'SV'=>'EL SALVADOR', 'GQ'=>'EQUATORIAL GUINEA', 'ER'=>'ERITREA', 'EE'=>'ESTONIA', 'ET'=>'ETHIOPIA', 
        'FK'=>'FALKLAND ISLANDS (MALVINAS)', 'FO'=>'FAROE ISLANDS', 'FJ'=>'FIJI', 'FI'=>'FINLAND', 'FR'=>'FRANCE', 'GF'=>'FRENCH GUIANA', 'PF'=>'FRENCH POLYNESIA', 
        'TF'=>'FRENCH SOUTHERN TERRITORIES', 'GA'=>'GABON', 'GM'=>'GAMBIA', 'GE'=>'GEORGIA', 'DE'=>'GERMANY', 'GH'=>'GHANA', 'GI'=>'GIBRALTAR', 'GR'=>'GREECE', 'GL'=>'GREENLAND', 'GD'=>'GRENADA', 
        'GP'=>'GUADELOUPE', 'GU'=>'GUAM', 'GT'=>'GUATEMALA', 'GG'=>'GUERNSEY', 'GN'=>'GUINEA', 'GW'=>'GUINEA-BISSAU', 'GY'=>'GUYANA', 'HT'=>'HAITI', 'HM'=>'HEARD ISLAND AND MCDONALD ISLANDS', 
        'VA'=>'HOLY SEE (VATICAN CITY STATE)', 'HN'=>'HONDURAS', 'HK'=>'HONG KONG', 'HU'=>'HUNGARY', 'IS'=>'ICELAND', 'IN'=>'INDIA', 'ID'=>'INDONESIA', 'IR'=>'IRAN', 
        'IQ'=>'IRAQ', 'IE'=>'IRELAND', 'IM'=>'ISLE OF MAN', 'IL'=>'ISRAEL', 'IT'=>'ITALY', 'JM'=>'JAMAICA', 'JP'=>'JAPAN', 'JE'=>'JERSEY', 'JO'=>'JORDAN', 'KZ'=>'KAZAKHSTAN', 'KE'=>'KENYA', 
        'KI'=>'KIRIBATI', 'KP'=>'DEMOCRATIC PEOPLE\'S REPUBLIC OF KOREA', 'KR'=>'REPUBLIC OF KOREA', 'KW'=>'KUWAIT', 'KG'=>'KYRGYZSTAN', 'LA'=>'LAO PEOPLE\'S DEMOCRATIC REPUBLIC', 
        'LV'=>'LATVIA', 'LB'=>'LEBANON', 'LS'=>'LESOTHO', 'LR'=>'LIBERIA', 'LY'=>'LIBYA', 'LI'=>'LIECHTENSTEIN', 'LT'=>'LITHUANIA', 'FI'=>'FINLAND', 'MO'=>'MACAO', 
        'MK'=>'MACEDONIA', 'MG'=>'MADAGASCAR', 'MW'=>'MALAWI', 'MY'=>'MALAYSIA', 'MV'=>'MALDIVES', 'ML'=>'MALI', 'MT'=>'MALTA', 'MH'=>'MARSHALL ISLANDS', 
        'MQ'=>'MARTINIQUE', 'MR'=>'MAURITANIA', 'MU'=>'MAURITIUS', 'YT'=>'MAYOTTE', 'MX'=>'MEXICO', 'FM'=>'FEDERATED STATES OF MICRONESIA', 'MD'=>' MOLDOVA', 'MC'=>'MONACO', 
        'MN'=>'MONGOLIA', 'ME'=>'MONTENEGRO', 'MS'=>'MONTSERRAT', 'MA'=>'MOROCCO', 'MZ'=>'MOZAMBIQUE', 'MM'=>'MYANMAR', 'NA'=>'NAMIBIA', 'NR'=>'NAURU', 'NP'=>'NEPAL', 'NL'=>'NETHERLANDS', 
        'NC'=>'NEW CALEDONIA', 'NZ'=>'NEW ZEALAND', 'NI'=>'NICARAGUA', 'NE'=>'NIGER', 'NG'=>'NIGERIA', 'NU'=>'NIUE', 'NF'=>'NORFOLK ISLAND', 'MP'=>'NORTHERN MARIANA ISLANDS', 'NO'=>'NORWAY', 
        'OM'=>'OMAN', 'PK'=>'PAKISTAN', 'PW'=>'PALAU', 'PS'=>'PALESTINIAN TERRITORY, OCCUPIED', 'PA'=>'PANAMA', 'PG'=>'PAPUA NEW GUINEA', 'PY'=>'PARAGUAY', 'PE'=>'PERU', 'PH'=>'PHILIPPINES', 
        'PN'=>'PITCAIRN', 'PL'=>'POLAND', 'PT'=>'PORTUGAL', 'PR'=>'PUERTO RICO', 'QA'=>'QATAR', 'RE'=>'RÉUNION', 'RO'=>'ROMANIA', 'RU'=>'RUSSIAN FEDERATION', 'RW'=>'RWANDA', 
        'BL'=>'SAINT BARTHÉLEMY', 'SH'=>'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA', 'KN'=>'SAINT KITTS AND NEVIS', 'LC'=>'SAINT LUCIA', 'MF'=>'SAINT MARTIN (FRENCH PART)', 
        'PM'=>'SAINT PIERRE AND MIQUELON', 'VC'=>'SAINT VINCENT AND THE GRENADINES', 'WS'=>'SAMOA', 'SM'=>'SAN MARINO', 'ST'=>'SAO TOME AND PRINCIPE', 'SA'=>'SAUDI ARABIA', 'SN'=>'SENEGAL', 
        'RS'=>'SERBIA', 'SC'=>'SEYCHELLES', 'SL'=>'SIERRA LEONE', 'SG'=>'SINGAPORE', 'SX'=>'SINT MAARTEN (DUTCH PART)', 'SK'=>'SLOVAKIA', 'SI'=>'SLOVENIA', 'SB'=>'SOLOMON ISLANDS', 
        'SO'=>'SOMALIA', 'ZA'=>'SOUTH AFRICA', 'GS'=>'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'SS'=>'SOUTH SUDAN', 'ES'=>'SPAIN', 'LK'=>'SRI LANKA', 'SD'=>'SUDAN', 'SR'=>'SURINAME', 
        'SJ'=>'SVALBARD AND JAN MAYEN', 'SZ'=>'SWAZILAND', 'SE'=>'SWEDEN', 'CH'=>'SWITZERLAND', 'SY'=>'SYRIAN ARAB REPUBLIC', 'TW'=>'TAIWAN', 'TJ'=>'TAJIKISTAN', 
        'TZ'=>'TANZANIA', 'TH'=>'THAD', 'TL'=>'TIMOR-LESTE', 'TG'=>'TOGO', 'TK'=>'TOKELAU', 'TO'=>'TONGA', 'TT'=>'TRINIDAD AND TOBAGO', 'TN'=>'TUNISIA', 'TR'=>'TURKEY', 
        'TM'=>'TURKMENISTAN', 'TC'=>'TURKS AND CAICOS ISLANDS', 'TV'=>'TUVALU', 'UG'=>'UGANDA', 'UA'=>'UKRAINE', 'AE'=>'UNITED ARAB EMIRATES', 'GB'=>'UNITED KINGDOM', 'US'=>'UNITED STATES', 
        'UM'=>'UNITED STATES MINOR OUTLYING ISLANDS', 'UY'=>'URUGUAY', 'UZ'=>'UZBEKISTAN', 'VU'=>'VANUATU', 'VE'=>'VENEZUELA', 'VN'=>'VIET NAM', 
        'VG'=>'VIRGIN ISLANDS, BRITISH', 'VI'=>'VIRGIN ISLANDS, U.S.', 'WF'=>'WALLIS AND FUTUNA', 'EH'=>'WESTERN SAHARA', 'YE'=>'YEMEN', 'ZM'=>'ZAMBIA', 'ZW'=>'ZIMBABWE', 'KV'=>'KOSOVO'};

    public static Map<String,String> name2cc = new Map<String,String> {'AND'=>'AD', 'ANDORRA'=>'AD', 'PRINCIPALITY OF ANDORRA'=>'AD', 'UAE'=>'AE', 'ARE'=>'AE', 'DB'=>'AE', 'DUBAI'=>'AE', 'UNITED ARAB EMIRATES'=>'AE', 
        'AFG'=>'AF', 'AFGHANISTAN'=>'AF', 'ANTIGUA AND BARBUDA'=>'AG', 'ATG'=>'AG', 'AIA'=>'AI', 'ANGUILLA'=>'AI', 'ALB'=>'AL', 'ALBANIA'=>'AL', 'ARM'=>'AM', 'ARMENIA'=>'AM', 'AGO'=>'AO', 
        'ANGOLA'=>'AO', 'ANTARCTICA'=>'AQ', 'ATA'=>'AQ', 'ARG'=>'AR', 'ARGENTINA'=>'AR', 'AMERICAN SAMOA'=>'AS', 'ASM'=>'AS', 'AUSTRIA'=>'AT', 'AUT'=>'AT', 'AUS'=>'AU', 'AUSTRALIA'=>'AU', 'ABW'=>'AW', 
        'ARUBA'=>'AW', 'ALA'=>'AX', 'ÅLAND ISLANDS'=>'AX', 'AZE'=>'AZ', 'AZERBAIJAN'=>'AZ', 'B-H'=>'BA', 'BIH'=>'BA', 'BOSNIA AND HERZEGOVINA'=>'BA', 'BOSNIA-HERZEGOVINA'=>'BA', 'BARBADOS'=>'BB', 
        'BRB'=>'BB', 'BANGLADESH'=>'BD', 'BGD'=>'BD', 'BEL'=>'BE', 'BELGIUM'=>'BE', 'BFA'=>'BF', 'BURKINA FASO'=>'BF', 'BGR'=>'BG', 'BULGARIA'=>'BG', 'BAHRAIN'=>'BH', 'BHR'=>'BH', 'BDI'=>'BI', 
        'BURUNDI'=>'BI', 'BEN'=>'BJ', 'BENIN'=>'BJ', 'BLM'=>'BL', 'SAINT BARTHELEMY'=>'BL', 'SAINT BARTHÉLEMY'=>'BL', 'ST. BARTHÉLEMY'=>'BL', 'BERMUDA'=>'BM', 'BMU'=>'BM', 'BRN'=>'BN', 
        'BRUNEI DARUSSALAM'=>'BN', 'BOL'=>'BO', 'BOLIVIA'=>'BO', 'BES'=>'BQ', 'BONAIRE, SINT EUSTATIUS AND SABA'=>'BQ', 'BRA'=>'BR', 'BRAZIL'=>'BR', 'BAHAMAS'=>'BS', 'BHS'=>'BS', 'BHUTAN'=>'BT', 
        'BTN'=>'BT', 'BOUVET ISLAND'=>'BV', 'BVT'=>'BV', 'BOTSWANA'=>'BW', 'BWA'=>'BW', 'BELARUS'=>'BY', 'BLR'=>'BY', 'BELIZE'=>'BZ', 'BLZ'=>'BZ', 'CAN'=>'CA', 'CAN'=>'CA', 'CANADA'=>'CA', 'CCK'=>'CC', 
        'COCOS (KEELING) ISLANDS'=>'CC', 'COCOS ISLANDS'=>'CC', 'KEELING ISLANDS'=>'CC', 'COD'=>'CD', 'DRC'=>'CD', 'THE DEMOCRATIC REPUBLIC OF THE CONGO'=>'CD', 'CAF'=>'CF', 'CENTRAL AFRICAN REPUBLIC'=>'CF', 
        'COG'=>'CG', 'CONGO'=>'CG', 'CHE'=>'CH', 'SWITZERLAND'=>'CH', 'CIV'=>'CI', 'CÔTE D\'IVOIRE'=>'CI', 'COK'=>'CK', 'COOK ISLANDS'=>'CK', 'CHILE'=>'CL', 'CHL'=>'CL', 'CAMEROON'=>'CM', 'CMR'=>'CM', 
        'PRC'=>'CN', 'CHINA'=>'CN', 'PEOPLE\'S REPUBLIC OF CHINA'=>'CN', 'CHN'=>'CN', 'COL'=>'CO', 'COLOMBIA'=>'CO', 'COSTA RICA'=>'CR', 'CRI'=>'CR', 'CUB'=>'CU', 'CUBA'=>'CU', 'CAPE VERDE'=>'CV', 
        'CPV'=>'CV', 'CVI'=>'CV', 'CURAÇAO'=>'CW', 'CUW'=>'CW', 'CHRISTMAS ISLAND'=>'CX', 'CXR'=>'CX', 'CYP'=>'CY', 'CYPRUS'=>'CY', 'CS'=>'CZ', 'CZE'=>'CZ', 'CZECH'=>'CZ', 'CZECH REPUBLIC'=>'CZ', 
        'CZECHOSLOVAKIA'=>'CZ', 'DEU'=>'DE', 'DEUTSCHLAND'=>'DE', 'FRG'=>'DE', 'GERMANY'=>'DE', 'GFR'=>'DE', 'DJI'=>'DJ', 'DJIBOUTI'=>'DJ', 'DENMARK'=>'DK', 'DNK'=>'DK', 'DMA'=>'DM', 'DOMINICA'=>'DM', 
        'DOM'=>'DO', 'RD'=>'DO', 'DOMINICAN REPUBLIC'=>'DO', 'ALGERIA'=>'DZ', 'DZA'=>'DZ', 'ECU'=>'EC', 'ECUADOR'=>'EC', 'EST'=>'EE', 'ESTONIA'=>'EE', 'ARAB REPUBLIC OF EGYPT'=>'EG', 'ARE'=>'EG', 
        'EGY'=>'EG', 'EGYPT'=>'EG', 'ESH'=>'EH', 'WESTERN SAHARA'=>'EH', 'ERI'=>'ER', 'ERITREA'=>'ER', 'ESP'=>'ES', 'SPAIN'=>'ES', 'ETH'=>'ET', 'ETHIOPIA'=>'ET', 'FIN'=>'FI', 'FINLAND'=>'FI', 
        'FIJI'=>'FJ', 'FJI'=>'FJ', 'FALKLAND ISLANDS (MALVINAS)'=>'FK', 'FLK'=>'FK', 'FEDERATED STATES OF MICRONESIA'=>'FM', 'FSM'=>'FM', 'MICORNESIA'=>'FM', 'FAROE ISLANDS'=>'FO', 'FRO'=>'FO', 
        'FRA'=>'FR', 'FRANCE'=>'FR', 'GAB'=>'GA', 'GABON'=>'GA', 'BRIT'=>'GB', 'BRITAIN'=>'GB', 'ENG'=>'GB', 'ENGLAND'=>'GB', 'GBNI'=>'GB', 'GBR'=>'GB', 'GREAT BRITAIN'=>'GB', 'NORTHERN IRELAND'=>'GB', 
        'SCOTLAND'=>'GB', 'U.K.'=>'GB', 'UK'=>'GB', 'UNITED KINGDOM'=>'GB', 'UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND'=>'GB', 'WALES'=>'GB', 'GRD'=>'GD', 'GRENADA'=>'GD', 'GEO'=>'GE', 
        'GEORGIA'=>'GE', 'FRENCH GUIANA'=>'GF', 'GUF'=>'GF', 'GGY'=>'GG', 'GUERNSEY'=>'GG', 'GHA'=>'GH', 'GHANA'=>'GH', 'GIB'=>'GI', 'GIBRALTAR'=>'GI', 'GREENLAND'=>'GL', 'GRL'=>'GL', 'GAMBIA'=>'GM', 
        'GMB'=>'GM', 'GIN'=>'GN', 'GUINEA'=>'GN', 'GLP'=>'GP', 'GUADELOUPE'=>'GP', 'EQUATORIAL GUINEA'=>'GQ', 'GNQ'=>'GQ', 'GRC'=>'GR', 'GREECE'=>'GR', ' SOUTH SANDWICH ISLANDS'=>'GS', 'SGS'=>'GS', 
        'SOUTH GEORGIA'=>'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS'=>'GS', 'GTM'=>'GT', 'GUATEMALA'=>'GT', 'GUAM'=>'GU', 'GUM'=>'GU', 'GNB'=>'GW', 'GUINEA-BISSAU'=>'GW', 'GUY'=>'GY', 
        'GUYANA'=>'GY', 'HKG'=>'HK', 'HONG KONG'=>'HK', 'HEARD ISLAND AND MCDONALD ISLANDS'=>'HM', 'HMD'=>'HM', 'HND'=>'HN', 'HONDURAS'=>'HN', 'CROATIA'=>'HR', 'HRV'=>'HR', 'HRVATSKA'=>'HR', 
        'HAITI'=>'HT', 'HTI'=>'HT', 'HUN'=>'HU', 'HUNGARY'=>'HU', 'IDN'=>'ID', 'INDO'=>'ID', 'INDONESIA'=>'ID', 'IRE'=>'IE', 'IRELAND'=>'IE', 'IRL'=>'IE', 'ISR'=>'IL', 'ISRAEL'=>'IL', 'IMN'=>'IM', 
        'ISLE OF MAN'=>'IM', 'IDA'=>'IN', 'IND'=>'IN', 'INDIA'=>'IN', 'BIOT'=>'IO', 'BRITISH INDIAN OCEAN TERRITORY'=>'IO', 'IOT'=>'IO', 'IRAQ'=>'IQ', 'IRQ'=>'IQ', 'IRAN'=>'IR', 'IRI'=>'IR', 'IRN'=>'IR', 
        'ISLAMIC REPUBLIC OF IRAN'=>'IR', 'ICELAND'=>'IS', 'ISL'=>'IS', 'ITA'=>'IT', 'ITALY'=>'IT', 'JERSEY'=>'JE', 'JEY'=>'JE', 'JAM'=>'JM', 'JAMAICA'=>'JM', 'HASHEMITE KINGDOM OF JORDAN'=>'JO', 
        'HKJ'=>'JO', 'JOR'=>'JO', 'JORDAN'=>'JO', 'JAPAN'=>'JP', 'JPN'=>'JP', 'KEN'=>'KE', 'KENYA'=>'KE', 'KGZ'=>'KG', 'KYRGYZSTAN'=>'KG', 'KYRGYZ REPUBLIC'=>'KG', 'KYRGYZSTAN'=>'KG', 
        'KINGDOM OF CAMBODIA'=>'KH', 'CAMBODIA'=>'KH', 'KHM'=>'KH', 'KIR'=>'KI', 'KIRIBATI'=>'KI', 'COM'=>'KM', 'COMOROS'=>'KM', 'KNA'=>'KN', 'SAINT KITTS AND NEVIS'=>'KN', 'ST. KITTS AND NEVIS'=>'KN', 
        'DEMOCRATIC PEOPLE\'S REPUBLIC OF KOREA'=>'KP', 'NK'=>'KP', 'DPRK'=>'KP', 'PDRK'=>'KP', 'NORTH KOREA'=>'KP', 'PRK'=>'KP', 'KOR'=>'KR', 'KOREA'=>'KR', 'REPUBLIC OF KOREA'=>'KR', 'KUWAIT'=>'KW', 
        'KWT'=>'KW', 'CAYMAN ISLANDS'=>'KY', 'CYM'=>'KY', 'KAZ'=>'KZ', 'KAZAKHSTAN'=>'KZ', 'LAO'=>'LA', 'LAOS'=>'LA', 'LBN'=>'LB', 'LEBANON'=>'LB', 'LCA'=>'LC', 'SAINT LUCIA'=>'LC', 'ST. LUCIA'=>'LC', 
        'LIE'=>'LI', 'LIECHTENSTEIN'=>'LI', 'LKA'=>'LK', 'SRI LANKA'=>'LK', 'LBR'=>'LR', 'LIBERIA'=>'LR', 'LESOTHO'=>'LS', 'LSO'=>'LS', 'LITHUANIA'=>'LT', 'LTU'=>'LT', 'LUX'=>'LU', 'LUXEMBOURG'=>'LU', 
        'LATVIA'=>'LV', 'LVA'=>'LV', 'LBY'=>'LY', 'LIBYA'=>'LY', 'MOR'=>'MA', 'MAR'=>'MA', 'MOROCCO'=>'MA', 'MCO'=>'MC', 'MONACO'=>'MC', 'REPUBLIC OF MOLDOVA'=>'MD', 'MDA'=>'MD', 'MOLDOVA'=>'MD', 
        'MON'=>'ME', 'MNE'=>'ME', 'MONTENEGRO'=>'ME', 'MAF'=>'MF', 'SAINT MARTIN'=>'MF', 'SAINT MARTIN (FRENCH PART)'=>'MF', 'ST. MARTEEN'=>'MF', 'ST. MARTIN'=>'MF', 'MADAGASCAR'=>'MG', 'MDG'=>'MG', 
        'RMI'=>'MH', 'REPUBLIC OF THE MARSHALL ISLANDS'=>'MH', 'MARSHALL ISLANDS'=>'MH', 'MHL'=>'MH', 'AYRM'=>'MK', 'FYROM'=>'MK', 'MACEDONIA'=>'MK', 'MKD'=>'MK', 'THE FORMER YUGOSLAV REPUBLIC OF MACEDONIA'=>'MK', 
        'MALI'=>'ML', 'MLI'=>'ML', 'MMR'=>'MM', 'MYANMAR'=>'MM', 'MNG'=>'MN', 'MONGOLIA'=>'MN', 'MAC'=>'MO', 'MACAO'=>'MO', 'MNP'=>'MP', 'NORTHERN MARIANA ISLANDS'=>'MP', 'MARTINIQUE'=>'MQ', 'MTQ'=>'MQ', 
        'RIM'=>'MR', 'MAURITANIA'=>'MR', 'MRT'=>'MR', 'MONTSERRAT'=>'MS', 'MSR'=>'MS', 'MALTA'=>'MT', 'MLT'=>'MT', 'MAURITIUS'=>'MU', 'MUS'=>'MU', 'MALDIVES'=>'MV', 'MDV'=>'MV', 'MALAWI'=>'MW', 'MWI'=>'MW', 
        'MEX'=>'MX', 'MEXICO'=>'MX', 'MALAYSIA'=>'MY', 'MYS'=>'MY', 'MOZ'=>'MZ', 'MOZAMBIQUE'=>'MZ', 'NAM'=>'NA', 'NAMIBIA'=>'NA', 'NCL'=>'NC', 'NEW CALEDONIA'=>'NC', 'NER'=>'NE', 'NIGER'=>'NE', 'NFK'=>'NF', 
        'NORFOLK ISLAND'=>'NF', 'NGA'=>'NG', 'NIGERIA'=>'NG', 'NIC'=>'NI', 'NICARAGUA'=>'NI', 'HL'=>'NL', 'HLL'=>'NL', 'HLL'=>'NL', 'NETHERLANDS'=>'NL', 'NLD'=>'NL', 'THE NETHERLANDS'=>'NL', 'NOR'=>'NO', 
        'NORWAY'=>'NO', 'NEPAL'=>'NP', 'NPL'=>'NP', 'NAURU'=>'NR', 'NRU'=>'NR', 'NIU'=>'NU', 'NIUE'=>'NU', 'NEW ZEALAND'=>'NZ', 'NZL'=>'NZ', 'OMAN'=>'OM', 'OMN'=>'OM', 'PAN'=>'PA', 'PANAMA'=>'PA', 'PER'=>'PE', 
        'PERU'=>'PE', 'FRENCH POLYNESIA'=>'PF', 'PYF'=>'PF', 'PAPUA NEW GUINEA'=>'PG', 'PNG'=>'PG', 'PHILIPPINES'=>'PH', 'RP'=>'PH', 'REPUBLIC OF THE PHILIPPINES'=>'PH', 'PHILS'=>'PH', 'PHI'=>'PH', 'PHL'=>'PH', 
        'IRP'=>'PK', 'ISLAMIC REPUBLIC OF PAKISTAN'=>'PK', 'PAK'=>'PK', 'PAKISTAN'=>'PK', 'POL'=>'PL', 'POLAND'=>'PL', 'SAINT PIERRE AND MIQUELON'=>'PM', 'SPM'=>'PM', 'PCN'=>'PN', 'PITCAIRN'=>'PN', 'PRI'=>'PR', 
        'PUERTO RICO'=>'PR', 'OCCUPIED PALESTINIAN TERRITORY'=>'PS', 'PSE'=>'PS', 'PORT'=>'PT', 'PORTUGAL'=>'PT', 'PRT'=>'PT', 'PALAU'=>'PW', 'PLW'=>'PW', 'PARAGUAY'=>'PY', 'PRY'=>'PY', 'QAT'=>'QA', 'QATAR'=>'QA', 
        'REU'=>'RE', 'REUNION'=>'RE', 'RÉUNION'=>'RE', 'ROMANIA'=>'RO', 'ROU'=>'RO', 'SERBIA'=>'RS', 'SRB'=>'RS', 'RSK'=>'RS', 'RUS'=>'RU', 'RUSSIA'=>'RU', 'RUSSIAN FEDERATION'=>'RU', 'RWA'=>'RW', 
        'RWANDA'=>'RW', 'SAU'=>'SA', 'SAUDI ARABIA'=>'SA', 'KINGDOM OF SAUDI ARABIA'=>'SA', 'KSA'=>'SA', 'SLB'=>'SB', 'SOLOMON ISLANDS'=>'SB', 'SEYCHELLES'=>'SC', 'SYC'=>'SC', 'SDN'=>'SD', 'SUDAN'=>'SD', 
        'SWE'=>'SE', 'SWEDEN'=>'SE', 'SGP'=>'SG', 'SINGAPORE'=>'SG', 'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA'=>'SH', 'SHN'=>'SH', 'SLOVENIA'=>'SI', 'SVN'=>'SI', 'SJM'=>'SJ', 'SVALBARD AND JAN MAYEN'=>'SJ', 
        'SLOVAKIA'=>'SK', 'SVK'=>'SK', 'SIERRA LEONE'=>'SL', 'SLE'=>'SL', 'SAN MARINO'=>'SM', 'REPUBLIC OF SAN MARINO'=>'SM', 'RSM'=>'SM', 'SMR'=>'SM', 'SEN'=>'SN', 'SENEGAL'=>'SN', 'SOM'=>'SO', 'SOMALIA'=>'SO', 
        'SUR'=>'SR', 'SURINAME'=>'SR', 'SOUTH SUDAN'=>'SS', 'SSD'=>'SS', 'SAO TOME AND PRINCIPE'=>'ST', 'STP'=>'ST', 'EL SALVADOR'=>'SV', 'SLV'=>'SV', 'SINT MAARTEN'=>'SX', 'SXM'=>'SX', 'SYR'=>'SY', 
        'SYRIA'=>'SY', 'SYRIAN ARAB REPUBLIC'=>'SY', 'SWAZILAND'=>'SZ', 'SWZ'=>'SZ', 'TCA'=>'TC', 'TURKS AND CAICOS ISLANDS'=>'TC', 'CHAD'=>'TD', 'TCD'=>'TD', 'ATF'=>'TF', 'FRENCH SOUTHERN TERRITORIES'=>'TF', 
        'TGO'=>'TG', 'TOGO'=>'TG', 'THA'=>'TH', 'THAI'=>'TH', 'THAILAND'=>'TH', 'TAJIKISTAN'=>'TJ', 'TJK'=>'TJ', 'TKL'=>'TK', 'TOKELAU'=>'TK', 'TIMOR-LESTE'=>'TL', 'TLS'=>'TL', 'TKM'=>'TM', 'TURKMENISTAN'=>'TM', 
        'TUN'=>'TN', 'TUNISIA'=>'TN', 'TON'=>'TO', 'TONGA'=>'TO', 'TUR'=>'TR', 'TURKEY'=>'TR', 'FRENCH SOUTHERN TERRITORIES'=>'TT', 'TRINIDAD AND TOBAGO'=>'TT', 'TUV'=>'TV', 'TUVALU'=>'TV', 'ROC'=>'TW', 
        'REPUBLIC OF CHINA'=>'TW', 'TAIWAN'=>'TW', 'TWN'=>'TW', 'TANZANIA'=>'TZ', 'TZA'=>'TZ', 'UKR'=>'UA', 'UKRAINE'=>'UA', 'UGA'=>'UG', 'UGANDA'=>'UG', 'UMI'=>'UM', 'ESTADOS UNIDOS'=>'US', 'ETATS UNIS'=>'US', 
        'U.S.'=>'US', 'U.S.A.'=>'US', 'UNITED STATES'=>'US', 'USA'=>'US', 'USA'=>'US', 'URUGUAY'=>'UY', 'URY'=>'UY', 'UZB'=>'UZ', 'UZBEKISTAN'=>'UZ', 'VATICAN CITY'=>'VA', 'VATICAN'=>'VA', 'HOLY SEE'=>'VA', 
        'VAT'=>'VA', 'SAINT VINCENT AND THE GRENADINES'=>'VC', 'VCT'=>'VC', 'VEN'=>'VE', 'VENEZUELA'=>'VE', 'BRITISH VIRGIN ISLANDS'=>'VG', 'VGB'=>'VG', 'U.S. VIRGIN ISLANDS'=>'VI', 'VIR'=>'VI', 
        'SOCIALIST REPUBLIC OF VIET NAM'=>'VN', 'VIET NAM'=>'VN', 'SRV'=>'VN', 'VNM'=>'VN', 'VANUATU'=>'VU', 'VUT'=>'VU', 'WALLIS AND FUTUNA'=>'WF', 'WLF'=>'WF', 'SAMOA'=>'WS', 'WSM'=>'WS', 'YEM'=>'YE', 
        'YEMEN'=>'YE', 'MAYOTTE'=>'YT', 'MYT'=>'YT', 'RSA'=>'ZA', 'REPUBLIC OF SOUTH AFRICA'=>'ZA', 'SOUTH AFRICA'=>'ZA', 'ZAF'=>'ZA', 'ZAMBIA'=>'ZM', 'ZMB'=>'ZM', 'ZIMBABWE'=>'ZW', 'ZWE'=>'ZW'};

    public static map<String,String> addressFormats = new Map<String,String> {'AF'=>'C', 'AG'=>'C', 'AI'=>'C', 'AL'=>'C', 'AO'=>'C', 'AQ'=>'C', 'AW'=>'C', 'BI'=>'C', 'BL'=>'C', 'BO'=>'C', 'BQ'=>'C', 
        'BS'=>'C', 'BT'=>'C', 'BV'=>'C', 'BW'=>'C', 'BZ'=>'C', 'CD'=>'C', 'CF'=>'C', 'CG'=>'C', 'CM'=>'C', 'CO'=>'C', 'CW'=>'C', 'DJ'=>'C', 'DM'=>'C', 'ER'=>'C', 'FJ'=>'C', 'GD'=>'C', 'GH'=>'C', 
        'GI'=>'C', 'GM'=>'C', 'GN'=>'C', 'GQ'=>'C', 'GY'=>'C', 'HK'=>'C', 'IQ'=>'C', 'JM'=>'C', 'KM'=>'C', 'KN'=>'C', 'KP'=>'C', 'LC'=>'C', 'LY'=>'C', 'MF'=>'C', 'ML'=>'C', 'MR'=>'C', 'MS'=>'C', 
        'MW'=>'C', 'NA'=>'C', 'NU'=>'C', 'PA'=>'C', 'PE'=>'C', 'PN'=>'C', 'PS'=>'C', 'QA'=>'C', 'RW'=>'C', 'SB'=>'C', 'SC'=>'C', 'SL'=>'C', 'SN'=>'C', 'SO'=>'C', 'SR'=>'C', 'SS'=>'C', 'ST'=>'C', 
        'SX'=>'C', 'TD'=>'C', 'TG'=>'C', 'TK'=>'C', 'TL'=>'C', 'TO'=>'C', 'TV'=>'C', 'TZ'=>'C', 'UG'=>'C', 'VC'=>'C', 'VU'=>'C', 'WS'=>'C', 'YE'=>'C', 'ZW'=>'C', 'VG'=>'C, S', 'CN'=>'C, SZ', 
        'MM'=>'C, Z', 'LV'=>'C,Z', 'TT'=>'C\nS', 'GG'=>'C\nS\nZ', 'IE'=>'C\nS\nZ', 'JE'=>'C\nS\nZ', 'EG'=>'C\nZ', 'FK'=>'C\nZ', 'GB'=>'C\nZ', 'GS'=>'C\nZ', 'IM'=>'C\nZ', 'KE'=>'C\nZ', 'RU'=>'C\nZ', 
        'SD'=>'C\nZ', 'SH'=>'C\nZ', 'SZ'=>'C\nZ', 'TC'=>'C\nZ', 'UA'=>'C\nZ', 'IO'=>'C\nZ', 'AE'=>'CS', 'KI'=>'CS', 'BD'=>'C-S', 'KY'=>'CS\nZ', 'AS'=>'CSZ', 'AU'=>'CSZ', 'CA'=>'CSZ', 'CC'=>'CSZ', 
        'CX'=>'CSZ', 'FM'=>'CSZ', 'GU'=>'CSZ', 'HM'=>'CSZ', 'LB'=>'CSZ', 'MH'=>'CSZ', 'MP'=>'CSZ', 'MU'=>'CSZ', 'NF'=>'CSZ', 'PR'=>'CSZ', 'PW'=>'CSZ', 'SA'=>'CSZ', 'UM'=>'CSZ', 'US'=>'CSZ', 
        'VI'=>'CSZ', 'ZA'=>'CSZ', 'BB'=>'CZ', 'BF'=>'CZ', 'BM'=>'CZ', 'BN'=>'CZ', 'ID'=>'CZ', 'IR'=>'CZ', 'JO'=>'CZ', 'KH'=>'CZ', 'KR'=>'CZ', 'MT'=>'CZ', 'MV'=>'CZ', 'NG'=>'CZ', 'NP'=>'CZ', 
        'NR'=>'CZ', 'NZ'=>'CZ', 'PM'=>'CZ', 'PY'=>'CZ', 'SG'=>'CZ', 'TH'=>'CZ', 'TW'=>'CZ', 'VN'=>'CZ', 'IN'=>'C-Z', 'PK'=>'C-Z', 'PG'=>'CZS', 'VE'=>'CZS', 'HU'=>' ', 'MO'=>' ', 'BJ'=>'Z\nC', 
        'EC'=>'Z\nC', 'NI'=>'Z\nC', 'UY'=>'Z\nC', 'AD'=>'ZC', 'AM'=>'ZC', 'AR'=>'ZC', 'AT'=>'ZC', 'AX'=>'ZC', 'AZ'=>'ZC', 'BA'=>'ZC', 'BE'=>'ZC', 'BG'=>'ZC', 'BH'=>'ZC', 'BY'=>'ZC', 'CH'=>'ZC',  
        'CI'=>'ZC', 'CK'=>'ZC', 'CL'=>'ZC', 'CR'=>'ZC', 'CU'=>'ZC', 'CY'=>'ZC', 'CZ'=>'ZC', 'DE'=>'ZC', 'DK'=>'ZC', 'DO'=>'ZC', 'DZ'=>'ZC', 'EE'=>'ZC', 'EH'=>'ZC', 'ES'=>'ZC', 'ET'=>'ZC', 'FI'=>'ZC', 
        'FO'=>'ZC', 'FR'=>'ZC', 'GA'=>'ZC', 'GE'=>'ZC', 'GF'=>'ZC', 'GL'=>'ZC', 'GP'=>'ZC', 'GR'=>'ZC', 'GW'=>'ZC', 'HN'=>'ZC', 'HR'=>'ZC', 'HT'=>'ZC', 'IL'=>'ZC', 'IS'=>'ZC', 'KG'=>'ZC', 'KW'=>'ZC', 
        'KZ'=>'ZC', 'LA'=>'ZC', 'LI'=>'ZC', 'LK'=>'ZC', 'LR'=>'ZC', 'LS'=>'ZC', 'LT'=>'ZC', 'LU'=>'ZC', 'MA'=>'ZC', 'MC'=>'ZC', 'MD'=>'ZC', 'ME'=>'ZC', 'MG'=>'ZC', 'MK'=>'ZC', 'MN'=>'ZC', 'MQ'=>'ZC', 
        'MZ'=>'ZC', 'NC'=>'ZC', 'NE'=>'ZC', 'NL'=>'ZC', 'NO'=>'ZC', 'OM'=>'ZC', 'PF'=>'ZC', 'PH'=>'ZC', 'PL'=>'ZC', 'PT'=>'ZC', 'RE'=>'ZC', 'RO'=>'ZC', 'RS'=>'ZC', 'SE'=>'ZC', 'SI'=>'ZC', 'SJ'=>'ZC', 
        'SK'=>'ZC', 'SM'=>'ZC', 'SY'=>'ZC', 'TF'=>'ZC', 'TJ'=>'ZC', 'TM'=>'ZC', 'TN'=>'ZC', 'TR'=>'ZC', 'UZ'=>'ZC', 'VA'=>'ZC', 'WF'=>'ZC', 'YT'=>'ZC', 'ZM'=>'ZC', 'GT'=>'Z-C', 'IT'=>'ZC(S)', 
        'MX'=>'ZC, S', 'CV'=>'ZC\nS', 'JP'=>'ZC\nS', 'MY'=>'ZC\nS', 'BR'=>'ZC-S', 'SV'=>'ZS\nC', 'XX'=>'CSZ'};

    public static String getStandardName(String nameIn)
    {
        // JV - 20171030 Added null check to the following if...
        if (nameIn != Null && name2cc.containsKey(nameIn.toUpperCase()))
        {
            return (cc2Name.get(name2cc.get(nameIn.toUpperCase())));
        }
        return 'UNITED STATES';
    }

    public static String formatAddress(String name, Address address) // Assume mailed from US
    {
        String fmtdAddress = formatAddress (name, Address, true);
        return fmtdAddress;
    }
    
    public static String formatAddress(String name, Address address, boolean isMailedFromUS)
    {
        AddressLines addrLines = new AddressLines(name,Address);
        String fmtdAddress = formatAddress(name, addrLines, isMailedFromUS);
        return fmtdAddress;
    }
    

/*  public static String formatAddress(String name, Address address, Boolean isMailedFromUS)
    {
        String countryName;
        String countryCode;
        String retStr = name;
        
        
        if (address.getCountry() != null)
        {
            // Determine the country
            //
            if (name2cc.containsKey(address.getCountry().toUppercase()))
            {
                countryCode = name2cc.get(address.getCountry().toUppercase()) ;
                countryName = cc2Name.get(countryCode);
            }
            else
            {
                if (cc2name.containsKey(address.getCountry().toUppercase()))
                {
                    countryCode = address.getCountry().toUppercase();
                    countryName = cc2Name.get(countryCode); 
                }
                else
                {
                    // If country is not null, but cannot be determined,
                    // default the format to US and use the specified value
                    // for the Country line.
                    countryCode = 'XX';
                    countryName = address.getCountry().toUppercase();
                }
            }
        }
        else
        {
            // If the address has no country, assume US.
            countryCode = 'US';
            countryName = cc2Name.get(countryCode);
        }
        //
        // Check for countries with unique formatting requirements
        //
        if (countryCode == 'HU')
        {
            // Hungary has a separate line for postal code
            if (address.getCity() != null)
            {
                retStr = retStr + '\n' + address.getCity() + ',';
            }
            if (address.getStreet() != null)
            {
                retStr = retStr + '\n' + address.getStreet();
            }
            if (address.getPostalCode() != null)
            {
                retStr = retStr + '\n' + address.getPostalCode();
            }
            retStr = retstr + '\n' + countryName;
            return retstr;
            
        }
        else
        {
            // Channel Islands have their own country code, but country  
            // is treated like city line and the country is set to "CHANNEL ISLANDS"
            //
            if (countryCode == 'JE' || countryCode == 'GG')
            {
                if (address.getStreet() != null)
                {
                    retStr = retStr + '\n' + address.getStreet();
                }
                if (address.getCity() != null)
                {
                    retStr = retStr + '\n' + address.getCity();
                }
                retStr = retStr + '\n'+ countryName;
                if (address.getpostalCode() != null)
                {
                    retStr = retStr + '\n' + address.getpostalCode();
                }
                retStr = retStr + '\n' + 'CHANNEL ISLANDS';
                return retStr;
            }
        }
        if (address.getStreet() != null)
        {
            retStr = retStr + '\n' + address.getStreet();           
        }
        String csz = processCSZ(address, countryCode);
        if (csz != '')
        {
            retStr = retStr + '\n' + csz;
        }
        if (!(isMailedFromUS && countryCode == 'US'))
        {
            retStr = retStr + '\n' + countryName;
        }
        System.debug('Formatted Address:\n' + retStr);
        return retStr;
    }
    
    public static String processCSZ(Address address, String countryCode)
    {
        String addressFormat = addressFormats.get(countryCode);
        String fmtChar;
        String retCSZ = '';
        Boolean haveOpenParen = false;
        
        for (Integer i=0; i < addressFormat.length(); i++)
        {
            fmtChar = addressFormat.mid(i,1);
            if (fmtChar == 'C')
            {
                if (address.getCity() != null)
                {
                    retCSZ = retCSZ +  address.getCity() + ' ';
                    haveOpenParen = false;
                }
            }
            else
            {
                if (fmtChar == 'S')
                {
                    if(address.getState() != null)
                    {
                        retCSZ = retCSZ + address.getState() + ' ';
                        haveOpenParen = false;
                    }
                }
                else
                {
                    if (fmtChar == 'Z')
                    {
                        if (address.getPostalCode() != null)
                        {
                            retCSZ = retCSZ + address.getPostalCode() + ' ';
                            haveOpenParen = false;                  
                        }
                    }               
                    else
                    {
                        if (fmtChar == '(')
                        {
                            haveOpenParen = true;
                            retCSZ = retCSZ + fmtChar;
                        }
                        else
                        {
                            if (fmtChar == ')')
                            {
                                if (haveOpenParen)
                                {
                                    retCSZ = retCSZ.remove('(');
                                    haveOpenParen = false;
                                }
                                else
                                {
                                    retCSZ = retCSZ.removeEnd(' ');
                                    retCSZ = retCSZ + fmtChar + ' ';
                                }
                            }
                            else
                            {
                                retCSZ = retCSZ.removeEnd(' ');
                                retCSZ = retCSZ + fmtChar;                          
                            }
                        }
                    }   
                }
            }
        }
        retCSZ = retCSZ.removeEnd(' ');
        return retCSZ;
    }*/
    
    public static String formatAddress(String name, AddressLines addrLines, Boolean isMailedFromUS)
    {
        String countryName;
        String countryCode;
        String retStr = name;
        String streetAddress = addrLines.street1;
        
        if (addrLines.street2 != null)
        {
            streetAddress = streetAddress + '\r\n' + addrLines.street2;
        }
        if (addrLines.street3 != null)
        {
            streetAddress = streetAddress + '\r\n' + addrLines.street3;
        }
        
        if (addrLines.country != null)
        {
            // Determine the country
            //
            if (name2cc.containsKey(addrLines.country.toUppercase()))
            {
                countryCode = name2cc.get(addrLines.country.toUppercase()) ;
                countryName = cc2Name.get(countryCode);
            }
            else
            {
                if (cc2name.containsKey(addrLines.country.toUppercase()))
                {
                    countryCode = addrLines.country.toUppercase();
                    countryName = cc2Name.get(countryCode); 
                }
                else
                {
                    // If country is not null, but cannot be determined,
                    // default the format to US and use the specified value
                    // for the Country line.
                    countryCode = 'XX';
                    countryName = addrLines.country.toUppercase();
                }
            }
        }
        else
        {
            // If the address has no country, assume US.
            countryCode = 'US';
            countryName = cc2Name.get(countryCode);
        }
        //
        // Check for countries with unique formatting requirements
        //
        if (countryCode == 'HU')
        {
            // Hungary has a separate line for postal code
            if (addrLines.city != null)
            {
                retStr = retStr + '\n' + addrLines.city + ',';
            }
            if (streetAddress != null)
            {
                retStr = retStr + '\n' + streetAddress;
            }
            if (addrLines.postalCode != null)
            {
                retStr = retStr + '\n' + addrLines.postalCode;
            }
            retStr = retstr + '\n' + countryName;
            return retstr;          
        }
        else
        {
            // Channel Islands have their own country code, but country  
            // is treated like city line and the country is set to "CHANNEL ISLANDS"
            //
            if (countryCode == 'JE' || countryCode == 'GG')
            {
                if (streetAddress != null)
                {
                    retStr = retStr + '\n' + streetAddress;
                }
                if (addrLines.city != null)
                {
                    retStr = retStr + '\n' + addrLines.city;
                }
                retStr = retStr + '\n'+ countryName;
                if (addrLines.postalCode != null)
                {
                    retStr = retStr + '\n' + addrLines.postalCode;
                }
                retStr = retStr + '\n' + 'CHANNEL ISLANDS';
                return retStr;
            }
        }
        if (streetAddress != null)
        {
            retStr = retStr + '\n' + streetAddress;         
        }
        String csz = processCSZ(addrLines, countryCode);
        if (csz != '')
        {
            retStr = retStr + '\n' + csz;
        }
        if (!(isMailedFromUS && countryCode == 'US'))
        {
            retStr = retStr + '\n' + countryName;
        }
        System.debug('Formatted Address:\n' + retStr);
        return retStr;
    }
    
    public static String processCSZ(AddressLines addrLines, String countryCode)
    {
        String addressFormat = addressFormats.get(countryCode);
        String fmtChar;
        String retCSZ = '';
        Boolean haveOpenParen = false;
        
        for (Integer i=0; i < addressFormat.length(); i++)
        {
            fmtChar = addressFormat.mid(i,1);
            if (fmtChar == 'C')
            {
                if (addrLines.city != null)
                {
                    retCSZ = retCSZ +  addrLines.city + ' ';
                    haveOpenParen = false;
                }
            }
            else
            {
                if (fmtChar == 'S')
                {
                    if(addrLines.stateProvince != null)
                    {
                        retCSZ = retCSZ + addrLines.stateProvince + ' ';
                        haveOpenParen = false;
                    }
                }
                else
                {
                    if (fmtChar == 'Z')
                    {
                        if (addrLines.postalCode != null)
                        {
                            retCSZ = retCSZ + addrLines.PostalCode + ' ';
                            haveOpenParen = false;                  
                        }
                    }               
                    else
                    {
                        if (fmtChar == '(')
                        {
                            haveOpenParen = true;
                            retCSZ = retCSZ + fmtChar;
                        }
                        else
                        {
                            if (fmtChar == ')')
                            {
                                if (haveOpenParen)
                                {
                                    retCSZ = retCSZ.remove('(');
                                    haveOpenParen = false;
                                }
                                else
                                {
                                    retCSZ = retCSZ.removeEnd(' ');
                                    retCSZ = retCSZ + fmtChar + ' ';
                                }
                            }
                            else
                            {
                                retCSZ = retCSZ.removeEnd(' ');
                                retCSZ = retCSZ + fmtChar;                          
                            }
                        }
                    }   
                }
            }
        }
        retCSZ = retCSZ.removeEnd(' ');
        return retCSZ;
    }
}