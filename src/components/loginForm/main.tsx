import { useState, type ChangeEvent, type FormEvent } from "react";
import useAuth from "../../stores/AuthStore";
import styles from "./style.module.css";
import GuardLoader from "../guarders/loader";

export function LoginModal({ close }: { close: () => void }) {
  
  const [isLoad,setLoad] = useState(false);
  const login = useAuth((state) => state.login);
  const [payload,setPayload] = useState({
    email: "",
    password: "" 
  });
  const [errors,setErrors] = useState({
    email: "",
    password: ""
  });
  
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    const {name,value} = e.target;

    setPayload((prevPayload) => ({
      ...prevPayload,
      [name]: value
    }))
    
    if (errors[name as "email" | "password"]) {
      setErrors((prev) => ({ ...prev, [name]: "" }));
    }
  }
  
  const validateForm = (): boolean => {
    let isValid = true;
    const newErrors = { email: "", password: "" };

    if (!payload.email.trim()) {
      newErrors.email = "Email обязателен для заполнения";
      isValid = false;
    } else if (!payload.email.includes("@")) { 
      newErrors.email = "Введите корректный email (должен содержать @)";
      isValid = false;
    }

    if (!payload.password) {
      newErrors.password = "Пароль не может быть пустым";
      isValid = false;
    } else if (payload.password.length < 6) {
      newErrors.password = "Пароль должен быть не менее 6 символов";
      isValid = false;
    }

    setErrors(newErrors);
    return isValid;
  };
  
  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    
    if(validateForm()){
      setLoad(true);
      await login(payload);
      setLoad(false);
      close();
    }
  }

  return (
    <div className={styles.loginCard}>
      <GuardLoader 
        isLoading={isLoad}
      >
      <form onSubmit={handleSubmit}>

        <h2 className={styles.title}>Вход в систему</h2>      
        <div className={styles.field}>
          <label>email пользователя</label>
          <input 
          name="email"
          onChange={handleChange} 
          value={payload.email} type="text" 
          placeholder="Введите gmail" 
          className={`${styles.input} ${errors.email ? styles.inputError : ""}`}
          />
          {errors.email && <span className={styles.errorText}>{errors.email}</span>}
        </div>

        <div className={styles.field}>
          <label>Пароль</label>
          <input 
          name="password"
          onChange={handleChange} 
          value={payload.password} type="password" 
          placeholder="••••••••" 
          className={`${styles.input} ${errors.password ? styles.inputError : ""}`}
          />
          {errors.password && <span className={styles.errorText}>{errors.password}</span>}    
        </div>

        <div className={styles.actions}>
          <button type="submit" className={styles.submitBtn}>Войти</button>
          <button type="button" className={styles.cancelBtn} onClick={close}>Отмена</button>
        </div>
      
      </form>
      </GuardLoader>
    </div>
  );
}

