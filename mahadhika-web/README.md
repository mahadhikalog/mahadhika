# Mahadhika Logistik Indonesia - Company Profile Website

> *Menyatukan Potensi, Membangun Negeri*

## 🚀 Tech Stack

- **Frontend Framework**: Vue.js 3 (Composition API with Script Setup)
- **Backend/Database**: Supabase
- **Hosting**: Firebase Hosting
- **Styling**: TailwindCSS
- **Build Tool**: Vite
- **State Management**: Pinia
- **Routing**: Vue Router

## 📦 Installation

1. Clone the repository
```bash
git clone <repository-url>
cd mahadhika-web
```

2. Install dependencies
```bash
npm install
```

3. Setup environment variables
```bash
cp .env.example .env
```
Edit `.env` and add your Supabase credentials:
- `VITE_SUPABASE_URL`: Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Your Supabase anonymous key

4. Run development server
```bash
npm run dev
```

5. Build for production
```bash
npm run build
```

6. Deploy to Firebase
```bash
npm run deploy:firebase
```
See [FIREBASE_QUICKSTART.md](./FIREBASE_QUICKSTART.md) for deployment guide.

## 📁 Project Structure

```
mahadhika-web/
├── public/              # Static assets
├── src/
│   ├── assets/         # Images, fonts, etc.
│   ├── components/     # Reusable Vue components
│   ├── composables/    # Vue composables
│   ├── layouts/        # Layout components
│   ├── lib/           # Supabase client & utilities
│   ├── pages/         # Page components
│   ├── router/        # Vue Router configuration
│   ├── stores/        # Pinia stores
│   ├── styles/        # Global styles
│   ├── App.vue        # Root component
│   └── main.js        # Entry point
├── docs/              # Documentation
└── package.json
```

## 🎨 Design System

### Colors
- **Primary (Navy Blue)**: From company logo
- **Accent (Red)**: From company logo
- **Neutral**: Grays for text and backgrounds

### Typography
- **Font Family**: Inter (Google Fonts)

## 📄 Documentation

See [docs/PRD.md](./docs/PRD.md) for detailed Product Requirements Document.

## 🔑 Key Features

- Responsive design (mobile-first)
- Modern UI/UX
- Contact form with Supabase integration
- Service showcase
- Company information
- Team members section
- Roadmap visualization

## 📝 License

Private - Mahadhika Logistik Indonesia

