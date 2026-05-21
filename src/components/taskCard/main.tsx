import type { Task } from "../../types/task";
import { Button } from "../btn/main"; // Импортируем ваш компонент кнопки
import styles from "./style.module.css";

interface TaskCardProps {
  task: Task;
  onAnswer?: (id: string) => void;
}

export function TaskCard({ task, onAnswer }: TaskCardProps) {
  
  // Определяем статус дедлайна
  const getDeadlineStatus = (endDate: Date) => {
    const now = new Date(); // Сейчас 21 мая 2026 года
    const timeLeftMs = endDate.getTime() - now.getTime();
    
    const hoursLeft = timeLeftMs / (1000 * 60 * 60);
    const daysLeft = hoursLeft / 24;

    // 1. Срок истек
    if (timeLeftMs <= 0) {
      return {
        className: styles.statusRed,
        text: "Срок сдачи истек!",
        isExpired: true // Флаг для блокировки кнопки
      };
    }

    // 2. Меньше 24 часов
    if (hoursLeft < 24) {
      return {
        className: styles.statusRed,
        text: `Сдача менее чем через ${Math.ceil(hoursLeft)} ч.`,
        isExpired: false
      };
    }

    // 3. Меньше 2 дней
    if (daysLeft <= 2) {
      return {
        className: styles.statusYellow,
        text: "До сдачи осталось 2 дня",
        isExpired: false
      };
    }

    // 4. Больше 2 дней
    return {
      className: styles.statusGreen,
      text: `До сдачи: ${Math.floor(daysLeft)} дн.`,
      isExpired: false
    };
  };

  const status = getDeadlineStatus(task.end_at);

  const formattedDate = task.end_at.toLocaleDateString("ru-RU", {
    day: "numeric",
    month: "long",
    hour: "2-digit",
    minute: "2-digit"
  });

  return (
    <div className={styles.card}>
      <h3 className={styles.title}>{task.title}</h3>
      
      <div className={styles.footer}>
        <div>
          <div className={status.className}>{status.text}</div>
          <small style={{ color: "var(--color-side-text)" }}>сдать до: {formattedDate}</small>
        </div>

        {/* 
          Используем вашу кастомную кнопку.
          Если status.isExpired равен true, то:
          1. Кнопка получает вариант 'ghost'
          2. Добавляется атрибут disabled, который блокирует клики
        */}
        <Button 
          variant={status.isExpired ? "ghost" : "primary"}
          onClick={() => !status.isExpired && onAnswer?.(task.id)}
          disabled={status.isExpired} 
        >
          {status.isExpired ? "Закрыто" : "Ответить"}
        </Button>
      </div>
    </div>
  );
}
