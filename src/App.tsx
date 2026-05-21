import { BrowserRouter, Route, Routes } from "react-router-dom"
import MainPage from "./pages/Main/page"
import { Header } from "./components/header/main"
import { ProfilePage } from "./pages/Profile/page"
import useAuth from "./stores/AuthStore"
import useTask from "./stores/TaskStore"
import useSettings from "./stores/SettingsStore"
import { useEffect, useState } from "react"
import GuardLoader from "./components/guarders/loader"



function App() {
  const [isLoad,setLoad] = useState(false);

  const getUser = useAuth(state => state.getUser);
  const getTasks = useTask(state => state.getTasks);
  const initSc = useSettings(state => state.init)   
  

  useEffect(() => {
    
    const InitStart = async () => {
      setLoad(true);
      await Promise.all([getUser(),initSc(),getTasks()]);
      setLoad(false);
    }
    InitStart();
  
  },[getUser,initSc,getTasks])
  


  return (
    <>
     <BrowserRouter>
        <Header />   

      <GuardLoader isLoading={isLoad}>
        <Routes>
          <Route path="/" element={<MainPage />} /> 
          <Route path="/me" element={<ProfilePage />} /> 
        </Routes>
      </GuardLoader>
    </BrowserRouter>         
    </>
  )
}

export default App
