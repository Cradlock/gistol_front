import type { Task } from "../types/task";

// Функция для получения ОДНОЙ задачи по id
export const getTaskApi = async (id: string): Promise<Task> => {
  return {
    id: id, 
    title: "Изучение препарата: Мазок крови человека (окраска по Романовскому-Гимзе)",
    year: 2026,
    start_at: new Date("2026-05-21T09:00:00"),
    end_at: new Date("2026-05-21T11:30:00")
  };
};

// Функция для получения СПИСКА задач с темами по гистологии
export const getTasksApi = async (): Promise<Task[]> => {
  return [
    {
      id: crypto.randomUUID(),
      title: "Повторение темы: Эпителиальные ткани. Классификация и строение",
      year: 1,
      start_at: new Date("2026-05-21T10:00:00"),
      end_at: new Date("2026-05-21T12:00:00")
    },
    {
      id: crypto.randomUUID(),
      title: "Разбор микропрепарата: Плотная оформленная соединительная ткань (сухожилие)",
      year: 1,
      start_at: new Date("2026-05-21T14:00:00"),
      end_at: new Date("2026-05-21T15:30:00")
    },
    {
      id: crypto.randomUUID(),
      title: "Оформление альбома: Скелетные мышечные ткани, структура саркомера",
      year: 1,
      start_at: new Date("2026-05-21T16:30:00"),
      end_at: new Date("2026-05-21T18:00:00")
    },
    {
      id: crypto.randomUUID(),
      title: "Подготовка к коллоквиуму: Нервная ткань и нейроглия (тигроид, клетки Ниссля)",
      year: 1,
      start_at: new Date("2026-05-22T09:00:00"),
      end_at: new Date("2026-05-22T12:00:00")
    }
  ];
};
