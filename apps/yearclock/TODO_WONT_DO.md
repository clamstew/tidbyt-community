# TODO_WONT_DO - Rejected Features

## ❌ EXPLICITLY WON'T DO

### Rejected Features

- **Date Positioning/Overlap Detection**: Too complex for minimal benefit
- **Birthday Mode**: PII concerns, poor UX
- **Team Colors**: Too niche, maintenance burden
- **Hebrew Calendar**: Complex lunar calculations beyond scope

### Detailed Rationale

#### Date Positioning/Overlap Detection
- **Problem**: Smart positioning to avoid dial marker overlap with date text
- **Why Rejected**: Implementation complexity far outweighs visual benefit
- **Alternative**: Current fixed positioning works well across all scenarios
- **Decision**: Keep simple, reliable positioning

#### Birthday Mode
- **Problem**: Personal birthday celebration themes
- **Why Rejected**: 
  - Requires collecting personal information (PII concerns)
  - Poor user experience for setup
  - Minimal benefit for single-day-per-year feature
- **Alternative**: Existing special date themes cover major celebrations
- **Decision**: Focus on universal celebrations

#### Team Colors
- **Problem**: Sports team color gradient themes
- **Why Rejected**:
  - Too niche - limited user base
  - High maintenance burden (hundreds of teams)
  - Color research complexity across global sports
  - Licensing/trademark concerns
- **Alternative**: User can configure custom color schemes if desired
- **Decision**: Out of scope for this app

#### Hebrew Calendar
- **Problem**: Jewish calendar integration and holiday support
- **Why Rejected**:
  - Requires complex lunar-solar calendar calculations
  - Hebrew calendar algorithms beyond current scope
  - Would need specialized libraries not available in Starlark
- **Alternative**: 6 other calendar systems already supported
- **Decision**: Phase 4+ enhancement if ever pursued

### Philosophy

These rejections follow core principles:
- **Simplicity over complexity**
- **Universal appeal over niche features**  
- **Privacy-conscious design**
- **Maintainable scope**
- **Technical feasibility within Starlark**

The app already provides rich customization within reasonable bounds. 