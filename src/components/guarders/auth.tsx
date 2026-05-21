
import useAuth from "../../stores/AuthStore";


interface AuthGuardProps {
  children: React.ReactNode;
  /** Что показать, если юзер НЕ вошел (например, кнопка "Войти") */
  fallback?: React.ReactNode; 
  /** Если true, то наоборот: скроет контент от авторизованных (например, форму регистрации) */
  guestOnly?: boolean; 
}

export function AuthGuard({ children, fallback, guestOnly = false }: AuthGuardProps) {
  const user = useAuth((state) => state.user);
  const isAuth = !!user; // Приводим к булеву значению

  // Если нам нужен только гость (например, для страницы Login), а юзер залогинен — скрываем
  if (guestOnly && isAuth) {
    return null; 
  }

  // Если нужен авторизованный, а юзера нет — показываем fallback или ничего
  if (!guestOnly && !isAuth) {
    return fallback || null;
  }

  return <>{children}</>;
}
