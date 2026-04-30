import type { NotifyType } from "../../types/notify";
import styles from "style.module.css";






export default function NotifyCard ({type,msg} : {type: NotifyType,msg:string}) {
  
  
  return (
    <div className={`${styles.container} ${styles[type]}`}>
        <p className={`${styles.text}`}>{msg}</p> 
    </div>
  );
};



