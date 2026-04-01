# System Design: Tyrian Purple UI Mockup

## Architecture Overview
The mockup will be a standalone, responsive HTML/CSS page served within the AureliusPress application. It will leverage modern CSS features (Flexbox, Grid, Custom Properties).

### Color Palette
- **Primary**: Tyrian Purple (`#66023C`)
- **Secondary**: Obsidian/Deep Charcoal (`#1A1A1B`)
- **Accent**: Champagne Gold (`#D4AF37`) for high-end highlights.
- **Surface**: Translucent Glass (White with `rgba(255, 255, 255, 0.15)`) for glassmorphism.

### Typography
- **Headings**: Serif font (e.g., *Playfair Display* via Google Fonts).
- **Body**: Clean Sans-Serif font (e.g., *Inter* or *Lato*).

### Components
1. **GlassNavbar**: Sticky header with `backdrop-filter: blur(10px)`.
2. **HeroSection**: Full-width container with a dynamic background image using `generate_image`.
3. **ContentGrid**: Responsive CSS Grid (`repeat(auto-fit, minmax(300px, 1fr))`).
4. **ArticleCard**: Modern card component with hover transitions.
5. **BrandFooter**: Minimalist footer using Tyrian Purple gradients.

### Interfaces & Traits
- **CSS Variables**: All colors and spacing will be defined as variables (`--primary-color`, `--spacing-unit`) for easy theme-switching.
- **Responsive Trait**: Utility classes for mobile/desktop layout shifts.

### Implementation Detail
- **Route**: `GET /mockups/tyrian_purple` (Mock controller and view).
- **Styles**: Defined in `app/assets/stylesheets/aurelius_press/themes/tyrian_purple.scss`.
