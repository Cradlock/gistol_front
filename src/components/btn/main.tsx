import type { ReactNode } from "react";
import styles from "./style.module.css";


interface props {
  children: ReactNode;
  onClick?: () => void;
  // Добавляем варианты
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
}

export function Button({ children, onClick, variant = 'primary' }: props) {
  // Динамически выбираем класс из стилей
  const btnClass = `${styles.btn} ${styles[variant]}`;

  return (
    <button className={btnClass} onClick={onClick}>
      {children}
    </button>
  );
}
