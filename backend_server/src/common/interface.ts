export interface IUser {
  id: number,
  user_id: string,
  name: string,
  email: string,
  password: string,
}

export type TCb = (err: NodeJS.ErrnoException | null) => void;
export type TCb1<T> = (err: NodeJS.ErrnoException | null, arg: T) => void;
