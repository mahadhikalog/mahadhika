# Product Requirements Document (PRD)
## Mahadhika Logistik Indonesia - Company Profile Website

---

## 1. Executive Summary

### 1.1 Project Overview
Company profile website untuk Mahadhika Logistik Indonesia yang bertujuan untuk menampilkan informasi perusahaan, layanan, dan memfasilitasi komunikasi dengan calon pelanggan dan mitra bisnis.

### 1.2 Objectives
- Membangun online presence yang profesional
- Menampilkan layanan dan keunggulan perusahaan
- Memfasilitasi komunikasi dengan prospek dan klien
- Memberikan informasi yang komprehensif tentang perusahaan

### 1.3 Target Audience
- Calon klien korporat (FMCG, BUMN, e-commerce)
- Potential business partners
- Investor dan stakeholder
- Pelamar kerja
- Media dan press

---

## 2. Technical Stack

### 2.1 Frontend
- **Framework**: Vue.js 3 (Composition API with Script Setup)
- **Routing**: Vue Router 4
- **State Management**: Pinia
- **Styling**: TailwindCSS 3
- **Build Tool**: Vite

### 2.2 Backend & Database
- **BaaS**: Supabase
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth (untuk admin dashboard - future)
- **Storage**: Supabase Storage (untuk gambar/dokumen)

### 2.3 Deployment
- **Hosting**: Vercel / Netlify (recommended)
- **Domain**: TBD

---

## 3. Feature Requirements

### 3.1 Core Pages

#### 3.1.1 Homepage
**Priority**: P0 (Critical)

**Sections**:
- Hero Section
  - Tagline: "Menyatukan Potensi, Membangun Negeri"
  - CTA buttons (Hubungi Kami, Lihat Layanan)
  - Background dengan visual logistics
  
- Tentang Kami (Brief)
  - Summary singkat perusahaan
  - Link ke About page
  
- Layanan Unggulan
  - 4 layanan utama dengan icon
  - Grid layout responsive
  
- Nilai Perusahaan (6 Values)
  - Visual card untuk: Harmonis, Empati, Sinergi, Adaptif, Teknologi, Integritas
  
- Sektor Industri
  - Showcase 6 sektor yang dilayani
  
- CTA Section
  - Form kontak atau link ke halaman kontak

#### 3.1.2 About Page
**Priority**: P0 (Critical)

**Sections**:
- Visi & Misi
- Tentang Kami (Full content)
- Nilai Perusahaan (Detail)
- Tim Pendiri (4 founders dengan foto dan jabatan)
- Keunggulan Kami (5 points)

#### 3.1.3 Services Page
**Priority**: P0 (Critical)

**Sections**:
- Layanan Kami (4 services detail)
  - Retail & Distribusi
  - Solusi Logistik
  - Transportasi
  - Pergudangan
  
- Sektor Industri (6 sectors)
  - Teknologi & Telekomunikasi
  - Energi & Pertambangan
  - Kesehatan & Farmasi
  - FMCG & Barang Konsumsi
  - E-Commerce & Ritel
  - Manufaktur & Industri

#### 3.1.4 Roadmap Page
**Priority**: P1 (High)

**Sections**:
- Timeline visualization (4 phases)
  - Tahun 0-1: Fondasi & Validasi
  - Tahun 1-3: Ekspansi Layanan
  - Tahun 3-5: Ekspansi Area
  - Tahun 5+: Leverage Business

#### 3.1.5 Contact Page
**Priority**: P0 (Critical)

**Sections**:
- Contact Information
  - Alamat Head Office
  - Email
  - Phone numbers (2 contacts)
  
- Contact Form
  - Fields: Nama, Email, Telepon, Perusahaan, Pesan
  - Submit ke Supabase database
  - Email notification (optional)
  
- Google Maps embed (Head Office location)

### 3.2 Components

#### 3.2.1 Navigation
- **Header/Navbar**
  - Logo
  - Menu: Beranda, Tentang, Layanan, Roadmap, Kontak
  - Mobile hamburger menu
  - Sticky/fixed on scroll

- **Footer**
  - Quick links
  - Contact information
  - Social media links (placeholder)
  - Copyright

#### 3.2.2 Reusable Components
- **ServiceCard**: Display service dengan icon & deskripsi
- **ValueCard**: Display nilai perusahaan
- **TeamCard**: Display anggota tim dengan foto
- **SectorCard**: Display sektor industri
- **TimelineItem**: Display roadmap timeline
- **ContactForm**: Form kontak dengan validasi
- **HeroSection**: Hero section dengan background
- **CTAButton**: Call-to-action button dengan variants

---

## 4. Database Schema (Supabase)

### 4.1 Tables

#### contacts
```sql
id: uuid (primary key)
created_at: timestamp
nama: text
email: text
telepon: text
perusahaan: text
pesan: text
status: text (new, contacted, closed)
```

#### services (optional - untuk dynamic content)
```sql
id: uuid (primary key)
title: text
description: text
icon: text
order: integer
active: boolean
```

#### team_members (optional - untuk dynamic content)
```sql
id: uuid (primary key)
name: text
position: text
role: text
photo_url: text
order: integer
```

---

## 5. User Stories

### 5.1 Visitor Stories

**US-01**: Sebagai visitor, saya ingin melihat informasi perusahaan agar saya memahami latar belakang dan kredibilitas Mahadhika Logistik.

**US-02**: Sebagai potential client, saya ingin melihat layanan yang ditawarkan agar saya bisa menentukan apakah sesuai kebutuhan bisnis saya.

**US-03**: Sebagai visitor, saya ingin menghubungi perusahaan melalui form kontak agar saya bisa mendapatkan informasi lebih lanjut atau penawaran.

**US-04**: Sebagai investor, saya ingin melihat roadmap perusahaan agar saya memahami visi jangka panjang dan strategi pertumbuhan.

**US-05**: Sebagai corporate client, saya ingin melihat sektor industri yang dilayani agar saya tahu apakah perusahaan memiliki pengalaman di industri saya.

---

## 6. Design Requirements

### 6.1 Design Principles
- **Modern & Professional**: Clean design yang mencerminkan profesionalisme
- **Mobile-First**: Responsive di semua device
- **User-Friendly**: Navigasi intuitif dan mudah dipahami
- **Performance**: Fast loading time (<3s)
- **Accessibility**: WCAG 2.1 Level AA compliance

### 6.2 Color Palette
- **Primary**: Navy Blue (#0a2847) - dari logo
- **Accent**: Red (#c41e3a) - dari logo
- **Neutral**: Gray scale untuk text dan background
- **Success**: Green untuk success states
- **White/Off-white**: untuk background sections

### 6.3 Typography
- **Heading Font**: Inter (Bold, SemiBold)
- **Body Font**: Inter (Regular, Medium)
- **Font Sizes**: Responsive (mobile: 14-32px, desktop: 16-48px)

### 6.4 UI Elements
- **Buttons**: Rounded corners (8px), dengan hover effects
- **Cards**: Shadow, rounded corners (12px)
- **Inputs**: Border dengan focus states
- **Icons**: Heroicons atau Lucide icons

---

## 7. Non-Functional Requirements

### 7.1 Performance
- Page load time < 3 seconds
- Lighthouse score > 90
- Image optimization (WebP format)
- Lazy loading untuk images

### 7.2 Security
- HTTPS only
- Form validation (client & server side)
- XSS protection
- CSRF protection
- Rate limiting untuk form submission

### 7.3 SEO
- Meta tags untuk setiap page
- Open Graph tags
- Sitemap.xml
- Robots.txt
- Structured data (JSON-LD)

### 7.4 Browser Support
- Chrome (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)
- Edge (latest 2 versions)
- Mobile browsers (iOS Safari, Chrome Mobile)

---

## 8. Development Phases

### Phase 1: Setup & Core Structure (Week 1)
- ✅ Project setup (Vite, Vue, Tailwind)
- ✅ Supabase configuration
- ✅ Routing setup
- ✅ Basic layout components (Header, Footer)

### Phase 2: Homepage & Static Pages (Week 1-2)
- Hero section
- About page
- Services page
- Reusable components

### Phase 3: Interactive Features (Week 2)
- Contact form
- Supabase integration
- Form validation
- Email notifications (optional)

### Phase 4: Roadmap & Polish (Week 2-3)
- Roadmap page dengan timeline
- Animation & transitions
- Image optimization
- Performance optimization

### Phase 5: Testing & Deployment (Week 3)
- Cross-browser testing
- Mobile testing
- SEO optimization
- Deployment to production

---

## 9. Future Enhancements (Post-Launch)

### 9.1 Phase 2 Features
- Blog/News section
- Case studies/Portfolio
- Testimonials dari clients
- Career/Job listing page
- Multi-language support (EN/ID)

### 9.2 Admin Dashboard
- Content management system
- Contact form management
- Analytics dashboard
- Service management

### 9.3 Advanced Features
- Live chat integration
- Shipment tracking (untuk clients)
- Quote calculator
- Newsletter subscription
- Integration dengan CRM

---

## 10. Success Metrics

### 10.1 Technical Metrics
- Page load time < 3s
- Lighthouse score > 90
- Zero critical bugs
- 99.9% uptime

### 10.2 Business Metrics
- Monthly visitors
- Contact form conversion rate
- Average time on site
- Bounce rate < 50%

---

## 11. Risks & Mitigation

### 11.1 Technical Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| Supabase downtime | High | Implement error handling, offline mode |
| Performance issues | Medium | Image optimization, code splitting |
| Browser compatibility | Low | Progressive enhancement, polyfills |

### 11.2 Business Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| Content changes | Medium | Use CMS for dynamic content |
| Spam submissions | Medium | Implement reCAPTCHA, rate limiting |
| Security vulnerabilities | High | Regular security audits, updates |

---

## 12. Appendix

### 12.1 Coding Standards
- **JavaScript**: camelCase untuk functions, snake_case untuk variables
- **Vue Components**: PascalCase
- **Database columns**: snake_case
- **CSS Classes**: kebab-case (Tailwind convention)

### 12.2 Git Workflow
- Main branch: `main` (production)
- Development branch: `develop`
- Feature branches: `feature/feature-name`
- Hotfix branches: `hotfix/issue-name`

### 12.3 Documentation
- Code comments untuk complex logic
- README.md untuk setup instructions
- Component documentation (props, events)
- API documentation (Supabase functions)

---

**Document Version**: 1.0  
**Last Updated**: 2025-10-01  
**Author**: Development Team  
**Status**: Draft

