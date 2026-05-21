
import { NavLink } from "react-router-dom";
import { useModal } from "../../hooks/useModal";
import { Button } from "../btn/main";
import { LoginModal } from "../loginForm/main";
import styles from "./style.module.css";
import { AuthGuard } from "../guarders/auth";
import useAuth from "../../stores/AuthStore";

export function Header() {
  const { setModal, closeModal } = useModal();
  const logout = useAuth((state) => state.logout);

  const handleOpenLogin = () => {
    setModal({ 
      child: <LoginModal close={closeModal} /> 
    });
  };

  return (
    <header className={styles.header}>
      <div className={styles.logo}>
        <NavLink to={"/"}>
          <span>Gistologia</span>
        </NavLink>
      </div>
      
       

      <div className={styles.actions}>
      
        <AuthGuard 
          fallback={
              <Button variant="primary" onClick={handleOpenLogin}>Войти</Button>
          }
        > 
          <NavLink to={"/me"}>
            <Button variant="primary">Профиль</Button>
          </NavLink>

          <NavLink to={"/"}>
            <Button variant="danger" onClick={logout}>Выйти</Button>
          </NavLink>
        </AuthGuard> 
      
      </div>

    </header>
  );
}


