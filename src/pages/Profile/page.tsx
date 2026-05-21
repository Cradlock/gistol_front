import useAuth from "../../stores/AuthStore";
import styles from "./style.module.css";

export function ProfilePage() {
  const user = useAuth((state) => state.user);

  // Если данных пользователя нет, показываем заглушку
  if (!user) {
    return (
      <div className={styles.container}>
        <div className={styles.card}>
          <p className={styles.unauthorized}>Пользователь не авторизован</p>
        </div>
      </div>
    );
  }

  // Берем первую букву имени для красивой аватарки-заглушки
  const avatarLetter = user.name ? user.name.charAt(0).toUpperCase() : "?";

  return (
    <div className={styles.container}>
      <div className={styles.card}>
        
        <div className={styles.header}>
          <div className={styles.avatarCircle}>
            {avatarLetter}
          </div>
          <h1 className={styles.title}>Профиль студента</h1>
        </div>

        <div className={styles.infoGroup}>
          <div className={styles.infoRow}>
            <span className={styles.label}>Имя:</span>
            <span className={styles.value}>{user.name}</span>
          </div>

          <div className={styles.infoRow}>
            <span className={styles.label}>Фамилия:</span>
            <span className={styles.value}>{user.surname}</span>
          </div>

          <div className={styles.infoRow}>
            <span className={styles.label}>Год обучения:</span>
            <span className={styles.value}>{user.year} курс</span>
          </div>

          <div className={styles.infoRow}>
            <span className={styles.label}>Группа:</span>
            <span className={styles.value}>{user.group}</span>
          </div>
        </div>

      </div>
    </div>
  );
}
