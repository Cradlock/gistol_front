


import styles from "./style.module.css";

export function LoginModal({ close }: { close: () => void }) {
  return (
    <div className={styles.loginCard}>
      <h2 className={styles.title}>Вход в систему</h2>
      
      <div className={styles.field}>
        <label>ID пользователя</label>
        <input type="text" placeholder="Введите ID" className={styles.input} />
      </div>

      <div className={styles.field}>
        <label>Пароль</label>
        <input type="password" placeholder="••••••••" className={styles.input} />
      </div>

      <div className={styles.actions}>
        <button className={styles.submitBtn}>Войти</button>
        <button className={styles.cancelBtn} onClick={close}>Отмена</button>
      </div>
    </div>
  );
}

