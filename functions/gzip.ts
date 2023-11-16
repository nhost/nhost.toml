import { Request, Response } from 'express'
import { gzipSync } from 'zlib';

export default (req: Request, res: Response) => {
    const body = "here is a body"
    res.setHeader('Content-Type', 'text/plain');

    console.log(req.headers['accept-encoding'])
    if (req.headers['accept-encoding']?.includes('gzip')) {
        let bodyCompressed = gzipSync(body)
        res.setHeader('Content-Encoding', 'gzip');
        res.setHeader('Content-Length', bodyCompressed.length);
        console.log('gzip', bodyCompressed.length, bodyCompressed)
        res.status(200).end(bodyCompressed)
    } else {
       console.log("no gzip!!!")
       res.status(200).end(body)
    }
}
