
import { useModal } from "../../hooks/useModal";
import { Button } from "../btn/main";
import { LoginModal } from "../loginForm/main";
import styles from "./style.module.css";

export function Header() {
  const { setModal, closeModal } = useModal();

  const handleOpenLogin = () => {
    setModal({ 
      child: <LoginModal close={closeModal} /> 
    });
  };

  return (
    <header className={styles.header}>
      <div className={styles.logo}>
        GISTOL <span>ACADEMY</span>
      </div>
      
      <nav className={styles.nav}>
      </nav>

      <div className={styles.actions}>
        <Button variant="primary" onClick={handleOpenLogin}>
          Войти
        </Button>
      </div>
    </header>
  );
}
