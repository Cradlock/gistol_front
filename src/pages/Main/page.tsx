import { AuthGuard } from "../../components/guarders/auth";
import { TaskList } from "../../components/taskList/main";

export default function MainPage() {
  

  return (
      <main>
      
        <AuthGuard>
          <TaskList />
        </AuthGuard>
      </main> 
  )
}




