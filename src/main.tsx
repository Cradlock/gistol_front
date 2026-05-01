import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { NotifyProvider } from './providers/NotifyProvider.tsx'
import { ModalProvider } from './providers/ModalProvider.tsx'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <NotifyProvider>
      <ModalProvider>
        <App />
      </ModalProvider>
    </NotifyProvider>
  </StrictMode>,
)
