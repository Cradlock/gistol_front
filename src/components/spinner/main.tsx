
import styles from "./style.module.css";

interface SpinnerProps {
  size?: number | string; // Можно передать число (24) или строку ("2rem")
  className?: string;     // Для внешних отступов
}

export default function Spinner({ size, className }: SpinnerProps) {
  // Формируем стиль: если передали число, добавим "px"
  const customStyle = size 
    ? { "--size": typeof size === 'number' ? `${size}px` : size } as React.CSSProperties 
    : {};

  return (
    <div 
      className={`${styles.spinner} ${className || ""}`} 
      style={customStyle}
    />
  );
}


