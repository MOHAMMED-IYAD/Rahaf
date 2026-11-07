RAHAF BIRTHDAY WEBSITE
======================

FILES
-----
index.html       Main page
style.css        Design and responsive layout
script.js        Language, login, sky chart and memories behavior
config.js        Supabase project URL, anon key and login email
schema.sql       Database + Row Level Security + private image storage policies

IMPORTANT: THE SKY MAP
----------------------
The sky is rendered by Virtual Sky (slowe.github.io/VirtualSky), an interactive planetarium embedded using its documented iframe endpoint.
It is not a decorative star illustration. The embedded VirtualSky chart uses the full-sky polar projection, deeper star magnitude, constellation labels, Milky Way, and coordinate grid. It is configured for the real calculated sky at:
- Gaza, Palestine: latitude 31.5, longitude 34.4667
- 7 November 2010 at 9:00 PM Gaza local time (UTC+2), which is 19:00 UTC
The time is explicitly an assumption because the actual birth time is unknown.
The chart is interactive; visitors can drag and explore it. It requires an internet connection. If the embedded frame is blocked by the browser or network, a direct-open fallback link appears below it.

SUPABASE SETUP (REQUIRED FOR PRIVATE LOGIN AND CLOUD MEMORIES)
-------------------------------------------------------------
1. Create a Supabase project at https://supabase.com/.
2. In Project Settings -> API, copy the Project URL and anon/public key.
3. Open config.js and replace YOUR_SUPABASE_PROJECT_URL and YOUR_SUPABASE_ANON_KEY.
   The configured loginEmail is rahaf@gmail.com. This email is used internally; Rahaf only enters the username and password on the website.
   Never put a service_role/secret key in config.js or any browser file.
4. In Supabase Authentication -> Providers, enable Email sign-in.
5. In Authentication -> Users, add a user:
      Email:    rahaf@gmail.com
      Password: 07112010
   Create/confirm this user from the dashboard. If you use a different email, update config.js too.
   The password is intentionally a birthday hint/entry feature, not strong security.
6. Open SQL Editor -> New query and run the COMPLETE schema.sql file. It creates the memories table, security policies, and private rahaf-memories bucket automatically.
8. Upload the whole project to a static host (for example Netlify). It must be served over HTTPS.

PRIVACY MODEL
-------------
- Guest mode only shows the public birthday content. It does not request or load memory records.
- Memory rows are protected by Supabase Row Level Security and tied to the authenticated user ID.
- Photos are stored in a private bucket and protected by Storage policies. Signed URLs are short-lived.
- The anon/public key is designed for browser use; database policies, not a hidden frontend password,
  enforce access. Never expose a service_role key.

NOTES
-----
- Memories are cloud-saved and available across devices after Rahaf signs in.
- Images are limited in the interface to 5 MB each.
- A stable internet connection is required for Supabase and the embedded astronomy chart.
- NASA's Hubble birthday page is a separate space-image feature, not a view of Gaza's local sky.
