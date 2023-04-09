import { Request, Response } from 'express'

export default (req: Request, res: Response) => {
    res.header('Content-Type', 'blah').
        header('X-Test', 'test').
        status(200).
        send(JSON.stringify(
            {
                headers: req.headers,
                query: req.query,
            },
        ),
    )
}
