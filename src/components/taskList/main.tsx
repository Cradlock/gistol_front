import { useModal } from "../../hooks/useModal";
import useTask from "../../stores/TaskStore";
import type { Task } from "../../types/task";
import { TaskCard } from "../taskCard/main";
import { TaskForm } from "../taskForm/main";
import styles from "./style.module.css";

export function TaskList() {
  const tasks = useTask((state) => state.tasks); 
  const {setModal,closeModal} = useModal();

  const handleAnswer = (task: Task) => {
    setModal({
      child: <TaskForm task={task} close={closeModal}/>
    });
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>Ваши задания по гистологии</h2>
      
      {tasks.length === 0 ? (
        <p className={styles.emptyText}>У вас нет активных задач на данный момент.</p>
      ) : (
        <div className={styles.list}>
          {tasks.map((task) => (
            <TaskCard 
              key={task.id} 
              task={task} 
              onAnswer={() => handleAnswer(task)} 
            />
          ))}
        </div>
      )}
    </div>
  );
}







