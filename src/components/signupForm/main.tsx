import styles from "./style.module.css";


export function signupForm({close} : {close: () => void}){
  
  return (
    <div className={styles.Card}>

      <div className={styles.actions}>
        <button className={styles.submitBtn}>Войти</button>
        <button className={styles.cancelBtn} onClick={close}>Отмена</button>
      </div>
    </div>
 
  )
}







