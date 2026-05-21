import type { Task } from "../../types/task";
import { Button } from "../btn/main";
import styles from "./style.module.css"

import { useState, type FormEvent, type ChangeEvent } from "react";

interface TaskFormProps {
  task: Task;       // Передаем задачу, на которую отвечаем
  close: () => void; // Функция закрытия модалки
}

export function TaskForm({ task, close }: TaskFormProps) {
  const [answer, setAnswer] = useState("");
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleChange = (e: ChangeEvent<HTMLTextAreaElement>) => {
    setAnswer(e.target.value);
    if (error) setError(""); 
  };

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    if (!answer.trim()) {
      setError("Ответ не может быть пустым. Напишите хотя бы пару слов.");
      return;
    }

    try {
      setIsSubmitting(true);

      await new Promise((resolve) => setTimeout(resolve, 1500));

      console.log(`Ответ на задачу ${task.id} успешно отправлен:`, answer);

      close();
    } catch (err) {
      console.error(err);
      setError("Не удалось отправить ответ. Попробуйте еще раз.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      <div>
        <h2 className={styles.taskTitle}>{task.title}</h2>
        <p className={styles.subtitle}>Форма отправки решения задания</p>
      </div>

      <div className={styles.field}>
        <textarea
          name="answer"
          value={answer}
          onChange={handleChange}
          placeholder="Введите ваш развернутый ответ на вопрос здесь..."
          className={styles.textarea}
          disabled={isSubmitting}
        />
      </div>

      {error && <p className={styles.errorText}>{error}</p>}

      <div className={styles.actions}>
        <Button 
          type="button" 
          variant="ghost" 
          onClick={close} 
          disabled={isSubmitting}
        >
          Отмена
        </Button>
        
        <Button 
          type="submit" 
          variant={isSubmitting ? "ghost" : "primary"}
          disabled={isSubmitting}
        >
          {isSubmitting ? "Отправка..." : "Отправить ответ"}
        </Button>
      </div>
    </form>
  );
}
