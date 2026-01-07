This system is built to restore last-known good release after a failed deployment.
Rollback matters because in production, deployments will fail, the system should be able to detect a bad deployment automatically, stop traffic to bad version and Restore the previous(last) stable version.

To run and test the app on Docker, you activate 2(two) terminals:
Terminal 1(one):                                                       Terminal 2(two)
docker build -t rollback-app.                                      curl http://localhost:8080/health 
docker run -p 8080:8080 -e FAIL_DEPLOYMENT=true rollback app

The commands on Terminal one should be run at different times. 
Run the first command you should see: 200 OK --> healthy
Run the second command you should see: 500 Internal Server Error --> unhealthy