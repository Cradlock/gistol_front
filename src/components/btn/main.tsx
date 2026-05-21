import type { ReactNode } from "react";
import styles from "./style.module.css"; // или откуда берутся стили

interface props {
  type?: "button" | "submit";
  children: ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  disabled?: boolean; // Добавляем проп disabled
}

export function Button({ children, type = "button",onClick, variant = 'primary', disabled = false }: props) {
  const btnClass = `${styles.btn} ${styles[variant]}`;

  return (
    <button 
      type={type}
      className={btnClass} 
      onClick={onClick}
      disabled={disabled} // Передаем его в HTML-элемент
    >
      {children}
    </button>
  );
}
