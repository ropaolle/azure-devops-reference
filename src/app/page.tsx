import { ReactNode } from "react";
import Logo from "./Logo";

export default function Home() {
  const Step = ({
    number,
    children,
  }: {
    number: number;
    children: ReactNode;
  }) => (
    <div className="mb-8 flex">
      <div className="relative mr-8 w-[20vw] text-right">
        <div className="absolute right-[-48px] mt-[-3px] flex h-8 w-8 items-center justify-center rounded-full bg-sky-500 text-sm font-semibold">
          {number}
        </div>
        {number % 2 !== 0 && children}
      </div>
      <div className="ml-8 w-[20vw]">{number % 2 === 0 && children}</div>
    </div>
  );

  return (
    <main className="flex min-h-screen flex-col items-center justify-between pt-[20vh]">
      <div className="flex max-w-full flex-col items-center">
        <div className="mb-12 text-center text-6xl font-bold text-slate-300 drop-shadow-lg">
          Azure <span className="text-red-700">DevOps</span> reference{" "}
          <span className="align-top text-xs">app</span>
        </div>

        <div className="relative overflow-clip pt-4">
          <div className="text-slate-200">
            <div className="flex flex-col items-center text-slate-200">
              <div className="absolute mt-1 h-full w-2 bg-sky-500"></div>
            </div>
            <Step number={1}>
              <div className="font-semibold">Plan a new feature</div>
              <div className="text-xs text-slate-400">
                We do it with GitHub Projects
              </div>
            </Step>
            <Step number={2}>
              <div className="font-semibold">Code the new feature</div>
              <div className="text-xs text-slate-400">
                Checkout main, create a new feature branch and start your
                favorite editor
              </div>
            </Step>
            <Step number={3}>
              <div className="font-semibold">Lint, test, and build</div>
              <div className="text-xs text-slate-400">
                Triggered automatically when a feature branch is pushed
              </div>
            </Step>
            <Step number={4}>
              <div className="font-semibold">Deploy container to Azure</div>
              <div className="text-xs text-slate-400">
                Pull request against the main branch trigger a deploy
              </div>
            </Step>
            <Step number={5}>
              <div className="font-semibold">Monitor the app</div>
              <div className="text-xs text-slate-400">
                We use various Azure monitor services to make sure the app works
                as expected
              </div>
            </Step>
          </div>
        </div>

        <a href="https://github.com/ropaolle/devops-dev" target="_blank">
          <div className="absolute right-0 top-0 w-48">
            <Logo />
          </div>
        </a>
      </div>
      <div className="mt-4 text-center">
        <div className="text-slate-300 ">By RopaOlle, © 2023</div>
        <div className="mb-2 text-xs text-slate-400">
          Build: {process.env.npm_package_version} (
          {new Date().toLocaleString("sv-SE", { timeZone: "UTC" })})
        </div>
      </div>
    </main>
  );
}
